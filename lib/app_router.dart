import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';

/// Creates the single root GoRouter for CitizenOne App.
/// Accepts the list of active enabled modules generated at build time.
GoRouter createAppRouter(List<AppModule> modules) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => RootHomeScreen(enabledModules: modules),
      ),
      ...modules.expand((module) => module.routes),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: AppErrorView(
        title: '404 - Page Not Found',
        message:
            'The path "${state.uri.path}" is not available in the current build configuration.',
        onRetry: () => context.go('/'),
      ),
    ),
  );
}

/// Root Landing Dashboard listing active business modules in current build
class RootHomeScreen extends StatelessWidget {
  final List<AppModule> enabledModules;

  const RootHomeScreen({super.key, required this.enabledModules});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CitizenOne SuperApp'),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout ${state.user.username}',
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    context.go('/login');
                  },
                );
              }
              return TextButton.icon(
                onPressed: () => context.push('/login'),
                icon: const Icon(Icons.login, color: Colors.white),
                label:
                    const Text('Login', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return AppCard(
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Authenticated User: ${state.user.username}',
                                  style: AppTypography.subtitle
                                      .copyWith(fontWeight: FontWeight.bold)),
                              Text(
                                  'Email: ${state.user.email} | Roles: ${state.user.roles.join(', ')}',
                                  style: AppTypography.caption),
                            ],
                          ),
                        ),
                        AppButton(
                          label: 'Logout',
                          isOutlined: true,
                          onPressed: () => context.read<AuthCubit>().logout(),
                        ),
                      ],
                    ),
                  );
                }

                return AppCard(
                  color: Colors.amber.shade50,
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 36, color: Colors.amber),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Guest Session',
                                style: AppTypography.subtitle),
                            Text(
                                'Login via CitizenOne module to access full features.',
                                style: AppTypography.caption),
                          ],
                        ),
                      ),
                      AppButton(
                        label: 'Sign In',
                        onPressed: () => context.push('/login'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  const Icon(Icons.layers_outlined, size: 40),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modular Architecture POC',
                          style: AppTypography.title,
                        ),
                        Text(
                          'Enabled Modules: ${enabledModules.length}',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Active Business Modules', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            if (enabledModules.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child:
                      Text('No business modules enabled in build/modules.yaml'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enabledModules.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final module = enabledModules[index];
                  final routePath = '/${module.id}';
                  return AppCard(
                    onTap: () => context.push(routePath),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          module.id.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(module.title, style: AppTypography.subtitle),
                      subtitle: Text('ID: ${module.id} | Route: $routePath',
                          style: AppTypography.caption),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
