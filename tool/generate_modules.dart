import 'dart:io';
import 'package:yaml/yaml.dart';

/// Known available business modules and their class metadata
class ModuleMetadata {
  final String id;
  final String importPath;
  final String className;

  const ModuleMetadata({
    required this.id,
    required this.importPath,
    required this.className,
  });
}

const Map<String, ModuleMetadata> availableModulesMap = {
  'citizen_one': ModuleMetadata(
    id: 'citizen_one',
    importPath: 'package:citizenone_app/modules/citizen_one/citizen_one.dart',
    className: 'CitizenOneModule',
  ),
  'agency_banking': ModuleMetadata(
    id: 'agency_banking',
    importPath:
        'package:citizenone_app/modules/agency_banking/agency_banking.dart',
    className: 'AgencyBankingModule',
  ),
  'kyc': ModuleMetadata(
    id: 'kyc',
    importPath: 'package:citizenone_app/modules/kyc/kyc.dart',
    className: 'KycModule',
  ),
  'loans': ModuleMetadata(
    id: 'loans',
    importPath: 'package:citizenone_app/modules/loans/loans.dart',
    className: 'LoansModule',
  ),
  'insurance': ModuleMetadata(
    id: 'insurance',
    importPath: 'package:citizenone_app/modules/insurance/insurance.dart',
    className: 'InsuranceModule',
  ),
};

void main(List<String> args) {
  String configPath = 'build/modules.yaml';

  for (final arg in args) {
    if (arg.startsWith('--config=')) {
      configPath = arg.substring('--config='.length);
    }
  }

  final configFile = File(configPath);
  if (!configFile.existsSync()) {
    stderr.writeln('Error: Configuration file not found at $configPath');
    exit(1);
  }

  final YamlMap yaml;
  try {
    final content = configFile.readAsStringSync();
    yaml = loadYaml(content) as YamlMap;
  } catch (e) {
    stderr.writeln('Error: Failed to parse YAML file at $configPath: $e');
    exit(1);
  }

  final rawModules = yaml['modules'];
  if (rawModules is! YamlList) {
    stderr.writeln('Error: "modules" key in $configPath must be a YAML list.');
    exit(1);
  }

  final selectedModules = <ModuleMetadata>[];
  for (final item in rawModules) {
    final id = item.toString().trim();
    if (!availableModulesMap.containsKey(id)) {
      stderr.writeln(
        'Error: Unknown module "$id" specified in $configPath.\n'
        'Available modules: ${availableModulesMap.keys.join(', ')}',
      );
      exit(1);
    }
    selectedModules.add(availableModulesMap[id]!);
  }

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer
      .writeln('// Generated from $configPath via tool/generate_modules.dart');
  buffer.writeln();
  buffer.writeln("import 'package:citizenone_app/core/core.dart';");

  for (final mod in selectedModules) {
    buffer.writeln("import '${mod.importPath}';");
  }

  buffer.writeln();
  buffer.writeln('/// List of active business modules enabled for this build.');
  buffer.writeln('final List<AppModule> enabledModules = <AppModule>[');
  for (final mod in selectedModules) {
    buffer.writeln('  ${mod.className}(),');
  }
  buffer.writeln('];');

  final outputDir = Directory('lib/generated');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final outputFile = File('${outputDir.path}/enabled_modules.dart');
  outputFile.writeAsStringSync(buffer.toString());

  stdout.writeln(
      'Successfully generated ${outputFile.path} with ${selectedModules.length} modules:');
  for (final mod in selectedModules) {
    stdout.writeln('  - ${mod.id} (${mod.className})');
  }
}
