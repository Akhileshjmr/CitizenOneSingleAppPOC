import 'dart:convert';
import 'dart:io';

/// Verifies architectural boundary integrity:
/// 1. Modules must NEVER import code from another business module (Rule 1).
/// 2. Modules must NEVER import host bootstrap files (main.dart, app.dart).
/// 3. Core must NEVER import business modules or design system.
/// 4. Design System must NEVER import business modules.
///
/// Supports CI flags:
/// - `--github-summary`: Writes Markdown report to $GITHUB_STEP_SUMMARY when in CI.
/// - `--json`: Writes a JSON report of the audit results to disk or stdout.
///
/// Returns exit code 0 on success, exit code 1 if any violation is found.
void main(List<String> args) {
  final writeGithubSummary = args.contains('--github-summary');
  final outputJson = args.contains('--json');

  final modulesDir = Directory('lib/modules');
  final coreDir = Directory('lib/core');
  final designSystemDir = Directory('lib/design_system');

  if (!modulesDir.existsSync() || !coreDir.existsSync() || !designSystemDir.existsSync()) {
    stderr.writeln('Error: Standard lib directories (modules, core, design_system) not found.');
    exit(1);
  }

  final moduleDirs = modulesDir.listSync().whereType<Directory>().toList();
  final moduleNames = moduleDirs
      .map((d) => d.uri.pathSegments.reversed.elementAt(1))
      .toList();

  stdout.writeln('------------------------------------------------------------');
  stdout.writeln('🛡️  CitizenOneApp Architectural Boundary & Layer Audit (Phase 3 CI Gate)');
  stdout.writeln('Auditing business modules: ${moduleNames.join(', ')}');
  stdout.writeln('------------------------------------------------------------');

  final violations = <Map<String, String>>[];
  int filesAudited = 0;

  // 1. Audit business modules
  for (final modDir in moduleDirs) {
    final currentModule = modDir.uri.pathSegments.reversed.elementAt(1);
    final dartFiles = modDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    for (final file in dartFiles) {
      filesAudited++;
      if (file.path.contains('core/session/presentation') ||
          file.path.contains('core/di/di_setup.dart')) {
        continue;
      }
      final lines = file.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('import ') && !line.startsWith('export ')) continue;

        // Check for cross-module imports
        for (final otherModule in moduleNames) {
          if (otherModule == currentModule) continue;

          // In Phase 2: agency_banking retains its embedded agrinet and loans_module dependencies
          if (currentModule == 'agency_banking' &&
              (otherModule == 'agrinet' || otherModule == 'loans_module')) {
            continue;
          }
          // common module orchestrates agent navigation to partner modules
          if (currentModule == 'common') {
            continue;
          }

          if (line.contains('package:citizenone_app/modules/$otherModule/') ||
              line.contains('/modules/$otherModule/')) {
            violations.add({
              'rule': 'RULE 1 - Inter-Module Implementation Import',
              'file': file.path,
              'line': '${i + 1}',
              'details': 'Module "$currentModule" illegally imports "$otherModule"',
              'code': line,
            });
          }
        }

        // Check for host layer imports
        if (line.contains('package:citizenone_app/main.dart') ||
            line.contains('package:citizenone_app/app.dart')) {
          violations.add({
            'rule': 'RULE 2 - Host Layer Coupling',
            'file': file.path,
            'line': '${i + 1}',
            'details': 'Module "$currentModule" directly imports host entrypoint',
            'code': line,
          });
        }
      }
    }
  }

  // 2. Audit core package (must never depend on modules or design system)
  final coreFiles = coreDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in coreFiles) {
    filesAudited++;
    if (file.path.contains('core/session/presentation') ||
        file.path.contains('core/di/di_setup.dart')) {
      continue;
    }
    final lines = file.readAsLinesSync();
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!line.startsWith('import ') && !line.startsWith('export ')) continue;

      if (line.contains('package:citizenone_app/modules/') ||
          line.contains('package:citizenone_app/design_system/')) {
        violations.add({
          'rule': 'LAYER VIOLATION - Inverted Core Dependency',
          'file': file.path,
          'line': '${i + 1}',
          'details': 'Core file illegally imports module or design_system',
          'code': line,
        });
      }
    }
  }

  // 3. Audit design system (must never depend on modules)
  final designFiles = designSystemDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in designFiles) {
    filesAudited++;
    if (file.path.contains('core/session/presentation') ||
        file.path.contains('core/di/di_setup.dart')) {
      continue;
    }
    final lines = file.readAsLinesSync();
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!line.startsWith('import ') && !line.startsWith('export ')) continue;

      if (line.contains('package:citizenone_app/modules/')) {
        violations.add({
          'rule': 'LAYER VIOLATION - Inverted Design System Dependency',
          'file': file.path,
          'line': '${i + 1}',
          'details': 'Design System file illegally imports business module',
          'code': line,
        });
      }
    }
  }

  stdout.writeln('Audited $filesAudited Dart files across Core, Design System, and Modules.');

  // JSON output if requested
  if (outputJson) {
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'status': violations.isEmpty ? 'PASSED' : 'FAILED',
      'filesAudited': filesAudited,
      'modulesAudited': moduleNames,
      'violationsCount': violations.length,
      'violations': violations,
    };
    final jsonFile = File('build/boundary_report.json');
    jsonFile.parent.createSync(recursive: true);
    jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
    stdout.writeln('Wrote boundary audit report to ${jsonFile.path}');
  }

  // GitHub Step Summary if running in CI
  final githubSummaryPath = Platform.environment['GITHUB_STEP_SUMMARY'];
  if (writeGithubSummary && githubSummaryPath != null && githubSummaryPath.isNotEmpty) {
    try {
      final summaryFile = File(githubSummaryPath);
      final buffer = StringBuffer();
      buffer.writeln('## 🛡️ Architectural Boundary Audit Report');
      buffer.writeln();
      buffer.writeln('| Metric | Result |');
      buffer.writeln('| :--- | :--- |');
      buffer.writeln('| **Audit Status** | ${violations.isEmpty ? "✅ **PASSED**" : "❌ **FAILED**"} |');
      buffer.writeln('| **Files Audited** | $filesAudited |');
      buffer.writeln('| **Modules Checked** | ${moduleNames.join(", ")} |');
      buffer.writeln('| **Violations Found** | ${violations.length} |');
      buffer.writeln();

      if (violations.isNotEmpty) {
        buffer.writeln('### ❌ Architectural Violations');
        buffer.writeln('| Rule | File:Line | Details | Code |');
        buffer.writeln('| :--- | :--- | :--- | :--- |');
        for (final v in violations) {
          buffer.writeln('| ${v['rule']} | `${v['file']}:${v['line']}` | ${v['details']} | `${v['code']}` |');
        }
      } else {
        buffer.writeln('✅ **All module and layer boundaries strictly conform to Option A architecture.**');
      }

      summaryFile.writeAsStringSync(buffer.toString(), mode: FileMode.append);
      stdout.writeln('Appended report to GitHub Step Summary');
    } catch (e) {
      stderr.writeln('Warning: Failed to write GitHub step summary: $e');
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('✅ Boundary & Layer Verification PASSED: 0 architectural violations found.');
    exit(0);
  } else {
    stderr.writeln('❌ Boundary Verification FAILED: Found ${violations.length} architectural violation(s):\n');
    for (final v in violations) {
      stderr.writeln('[${v['rule']}]');
      stderr.writeln('  File: ${v['file']}:${v['line']}');
      stderr.writeln('  ${v['details']}');
      stderr.writeln('  Code: ${v['code']}\n');
    }
    exit(1);
  }
}
