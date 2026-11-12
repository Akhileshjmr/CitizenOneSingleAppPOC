import 'dart:io';

/// Installs Git pre-commit hooks for CitizenOneApp.
/// Configures Git to run `tool/verify_boundaries.dart` and `dart analyze` before every commit.
void main() {
  stdout.writeln('------------------------------------------------------------');
  stdout.writeln('⚙️  Installing CitizenOne Git Pre-Commit Quality Gate (Phase 3)');
  stdout.writeln('------------------------------------------------------------');

  final gitDir = Directory('.git');
  if (!gitDir.existsSync()) {
    stderr.writeln('Error: .git directory not found. Please run inside the repository root.');
    exit(1);
  }

  final sourceHook = File('.githooks/pre-commit');
  if (!sourceHook.existsSync()) {
    stderr.writeln('Error: Source hook .githooks/pre-commit not found.');
    exit(1);
  }

  // Method A: Set git config core.hooksPath to .githooks
  final gitConfigResult = Process.runSync('git', ['config', 'core.hooksPath', '.githooks']);
  if (gitConfigResult.exitCode == 0) {
    stdout.writeln('✔ Configured Git core.hooksPath = .githooks');
  }

  // Method B: Copy directly into .git/hooks/pre-commit for maximum reliability
  final targetHook = File('.git/hooks/pre-commit');
  targetHook.parent.createSync(recursive: true);
  sourceHook.copySync(targetHook.path);

  if (!Platform.isWindows) {
    Process.runSync('chmod', ['+x', targetHook.path]);
  }

  stdout.writeln('✔ Copied pre-commit hook to .git/hooks/pre-commit (executable)');
  stdout.writeln();
  stdout.writeln('✅ Pre-Commit Quality Gate successfully activated!');
  stdout.writeln('   Future git commits will automatically run:');
  stdout.writeln('   1. dart run tool/verify_boundaries.dart');
  stdout.writeln('   2. dart analyze --no-fatal-warnings lib');
}

