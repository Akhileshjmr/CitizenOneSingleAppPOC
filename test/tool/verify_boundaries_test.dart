import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architectural Boundary Tool (Phase 3 Quality Gate) Tests', () {
    test('verify_boundaries.dart passes on the current clean codebase', () {
      final result = Process.runSync(
        'dart',
        ['tool/verify_boundaries.dart', '--json'],
      );

      expect(result.exitCode, equals(0));
      expect(result.stdout.toString(), contains('Boundary & Layer Verification PASSED'));

      final reportFile = File('build/boundary_report.json');
      expect(reportFile.existsSync(), isTrue);

      final report = jsonDecode(reportFile.readAsStringSync()) as Map<String, dynamic>;
      expect(report['status'], equals('PASSED'));
      expect(report['violationsCount'], equals(0));
      expect(report['filesAudited'], isPositive);
    });

    test('verify_boundaries.dart writes markdown summary when GITHUB_STEP_SUMMARY is set', () {
      final tempDir = Directory.systemTemp.createTempSync('gh_summary_test');
      final summaryFile = File('${tempDir.path}/summary.md');

      final result = Process.runSync(
        'dart',
        ['tool/verify_boundaries.dart', '--github-summary'],
        environment: {'GITHUB_STEP_SUMMARY': summaryFile.path},
      );

      expect(result.exitCode, equals(0));
      expect(summaryFile.existsSync(), isTrue);

      final content = summaryFile.readAsStringSync();
      expect(content, contains('Architectural Boundary Audit Report'));
      expect(content, contains('PASSED'));

      tempDir.deleteSync(recursive: true);
    });
  });
}

