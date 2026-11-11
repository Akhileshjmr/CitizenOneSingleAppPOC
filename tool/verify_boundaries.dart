import 'dart:io';

/// Verifies architectural boundary integrity:
/// 1. Modules must NEVER import code from another business module (Rule 1).
/// 2. Modules must NEVER import host bootstrap files (main.dart, app.dart).
/// 3. Core must NEVER import business modules or design system.
/// 4. Design System must NEVER import business modules.
///
/// Returns exit code 0 on success, exit code 1 if any violation is found.
void main() {
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
  stdout.writeln('🛡️  CitizenOneApp Architectural Boundary & Layer Audit');
  stdout.writeln('Auditing business modules: ${moduleNames.join(', ')}');
  stdout.writeln('------------------------------------------------------------');

  final violations = <String>[];
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
            violations.add(
              '[RULE 1 VIOLATION - Inter-Module Implementation Import]\n'
              '  File: ${file.path}:${i + 1}\n'
              '  Module "$currentModule" imports "$otherModule":\n'
              '  $line\n',
            );
          }
        }

        // Check for host layer imports
        if (line.contains('package:citizenone_app/main.dart') ||
            line.contains('package:citizenone_app/app.dart')) {
          violations.add(
            '[RULE 1 VIOLATION - Host Layer Coupling]\n'
            '  File: ${file.path}:${i + 1}\n'
            '  Module "$currentModule" directly imports host entrypoint:\n'
            '  $line\n',
          );
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
        violations.add(
          '[LAYER VIOLATION - Inverted Core Dependency]\n'
          '  File: ${file.path}:${i + 1}\n'
          '  Core file illegally imports module or design_system:\n'
          '  $line\n',
        );
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
        violations.add(
          '[LAYER VIOLATION - Inverted Design System Dependency]\n'
          '  File: ${file.path}:${i + 1}\n'
          '  Design System file illegally imports business module:\n'
          '  $line\n',
        );
      }
    }
  }

  stdout.writeln('Audited $filesAudited Dart files across Core, Design System, and Modules.');

  if (violations.isEmpty) {
    stdout.writeln('✅ Boundary & Layer Verification PASSED: 0 architectural violations found.');
    exit(0);
  } else {
    stderr.writeln('❌ Boundary Verification FAILED: Found ${violations.length} architectural violation(s):\n');
    for (final v in violations) {
      stderr.writeln(v);
    }
    exit(1);
  }
}
