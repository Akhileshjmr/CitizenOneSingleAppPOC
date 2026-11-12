import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Module Generator Tool Tests', () {
    test('generate_modules.dart rejects duplicate canonical module selection', () {
      final tempDir = Directory.systemTemp.createTempSync('gen_test_dup');
      final configFile = File('${tempDir.path}/modules.yaml');
      // common and citizen_one map to the same CommonModule
      configFile.writeAsStringSync('''
modules:
  - common
  - citizen_one
''');

      final result = Process.runSync(
        'dart',
        ['tool/generate_modules.dart', '--config=${configFile.path}'],
      );

      expect(result.exitCode, equals(1));
      expect(result.stderr.toString(), contains('Duplicate module selection'));

      tempDir.deleteSync(recursive: true);
    });

    test('generate_modules.dart rejects unknown module ID', () {
      final tempDir = Directory.systemTemp.createTempSync('gen_test_unknown');
      final configFile = File('${tempDir.path}/modules.yaml');
      configFile.writeAsStringSync('''
modules:
  - nonexistent_module_xyz
''');

      final result = Process.runSync(
        'dart',
        ['tool/generate_modules.dart', '--config=${configFile.path}'],
      );

      expect(result.exitCode, equals(1));
      expect(result.stderr.toString(), contains('Unknown module "nonexistent_module_xyz"'));

      tempDir.deleteSync(recursive: true);
    });

    test('generate_modules.dart succeeds with valid modules', () {
      final tempDir = Directory.systemTemp.createTempSync('gen_test_valid');
      final configFile = File('${tempDir.path}/modules.yaml');
      configFile.writeAsStringSync('''
modules:
  - common
  - agency_banking
''');

      final result = Process.runSync(
        'dart',
        ['tool/generate_modules.dart', '--config=${configFile.path}'],
      );

      expect(result.exitCode, equals(0));
      expect(result.stdout.toString(), contains('Successfully generated'));

      // Restore default enabled_modules.dart
      Process.runSync('dart', ['run', 'tool/generate_modules.dart']);

      tempDir.deleteSync(recursive: true);
    });
  });
}

