# CitizenOne Modular Architecture Specification

## 1. Overview & Architectural Goals

**CitizenOne** is designed as a enterprise-grade, multi-package Flutter monorepo that provides digital financial and civic services. 

The primary architectural goal is to maintain **ONE Git repository / codebase**, while enabling management, build automation, and CI/CD pipelines to select which business modules are compiled into a specific build flavor or binary target.

### Key Highlights
- **Single Source of Truth**: All business modules exist within `packages/` in one repository.
- **Build-Time Selection**: Selection occurs before compilation via `build/modules.yaml` and `tool/generate_modules.dart`.
- **Zero Runtime Hiding Overhead**: Modules excluded from `build/modules.yaml` are neither imported nor instantiated in `enabled_modules.dart`, allowing Dart's static compiler and tree-shaker to optimize the final app bundle.
- **Strict Clean Architecture**: Every feature slice enforces clear layer boundaries: `Presentation (Cubit)` → `Domain (UseCase)` → `Data (Repository/API)` → `Core/Design System`.

---

## 2. Directory & Repository Structure

```text
citizenone/
│
├── apps/
│   └── citizenone_app/             # Main Application Shell
│       ├── lib/
│       │   ├── main.dart           # App entrypoint
│       │   ├── app.dart            # MaterialApp.router configuration
│       │   ├── app_router.dart     # Single root GoRouter combining active module routes
│       │   └── generated/
│       │       └── enabled_modules.dart # Generated build-time registry
│       └── pubspec.yaml
│
├── packages/
│   ├── core/                       # Shared HTTP client, AppModule contract, Auth/Security/Storage
│   ├── design_system/              # Reusable Material 3 UI components & typography
│   │
│   ├── citizen_one/                # Business Module: Citizen Services
│   ├── agency_banking/             # Business Module: Agency Banking & Agent Operations
│   ├── kyc/                        # Business Module: Identity Verification & Upload
│   ├── loans/                      # Business Module: Micro-Loans & Eligibility
│   └── insurance/                  # Business Module: Insurance Policies & Claims
│
├── build/
│   └── modules.yaml                # Build configuration file selecting enabled modules
│
├── tool/
│   └── generate_modules.dart       # Generator CLI reading YAML and creating enabled_modules.dart
│
├── docs/
│   └── architecture.md             # Detailed architectural documentation
│
├── melos.yaml                      # Monorepo task runner configuration
├── pubspec.yaml                    # Workspace root pubspec
└── README.md                       # Comprehensive guide and execution instructions
```

---

## 3. Package Layer Roles & Boundaries

### A. Core Package (`packages/core`)
`core` owns shared low-level application infrastructure. It **MUST NOT** depend on any business module or UI design components.
- **AppModule Interface**:
  ```dart
  abstract class AppModule {
    String get id;
    String get title;
    List<RouteBase> get routes;
    List<BlocProvider> get providers;
  }
  ```
- **ApiClient**: Standardized HTTP client handling base URLs, request execution, response decoding, headers, and error handling.
- **Network Interceptors**: Header injection (Authorization Bearer tokens), request/response logging, and standard timeout handling.
- **Security & Storage Utilities**: In-memory and local storage contracts, string masking utilities, base64 helpers.

### B. Design System Package (`packages/design_system`)
`design_system` owns generic UI components, typography, spacing tokens, and base Material 3 themes.
- **Components**: `AppButton`, `AppTextField`, `AppCard`, `AppLoader`, `AppErrorView`.
- **Tokens**: `AppSpacing` (xs, sm, md, lg, xl), `AppTypography` (display, title, subtitle, body, caption).
- **Rule**: Design System **MUST NOT** depend on business modules.

### C. Business Modules (`packages/*`)
Business modules represent domain domains (e.g. `agency_banking`, `kyc`, `loans`, `insurance`, `citizen_one`).
- Each module implements `AppModule`.
- Each module has its own independent theme extensions (`<module_name>_colors.dart`, `<module_name>_theme.dart`).
- Modules should remain decoupled from each other. Communication between modules, when required, should happen via abstract contracts registered in Core or deep linking via `GoRouter`.

---

## 4. Feature Architecture & Bloc/Cubit Flow

Inside every business module, functionality is organized into feature folders rather than global flat directories.

Example feature structure (`agency_banking/features/cash_deposit`):
```text
cash_deposit/
├── data/
│   ├── api/
│   │   └── cash_deposit_api.dart         # Endpoint paths & network request calls to Core ApiClient
│   ├── models/
│   │   └── cash_deposit_model.dart       # JSON serialization models
│   ├── datasources/
│   │   └── cash_deposit_remote_datasource.dart
│   └── repository/
│       └── cash_deposit_repository.dart  # Concrete implementation of domain repository
│
├── domain/
│   ├── entities/
│   │   └── cash_deposit_entity.dart      # Immutable business entities
│   └── usecases/
│       └── submit_cash_deposit.dart      # Pure business logic execution
│
├── presentation/
│   ├── cubit/
│   │   ├── cash_deposit_cubit.dart       # Cubit managing feature UI state
│   │   └── cash_deposit_state.dart       # Equatable state classes (Initial, Loading, Success, Failure)
│   ├── screens/
│   │   └── cash_deposit_screen.dart      # Flutter UI screen
│   └── widgets/
│       └── cash_deposit_card.dart        # Feature-specific widget
│
└── routes/
    └── cash_deposit_routes.dart          # Module feature GoRoute definitions
```

### Dependency Flow Contract
```text
[Screen / Widget] 
       ↓
[Cubit / Bloc] 
       ↓
[UseCase] 
       ↓
[Repository Contract] → [Repository Implementation] 
                                ↓
                        [Module API Class] 
                                ↓
                        [Core ApiClient]
```

---

## 5. Build-Time Module Selection vs Runtime Flags

### Runtime Flag Approach (Anti-Pattern)
```dart
// BAD: Everything compiled into binary; hidden behind flags
if (featureFlags.enableLoans) {
  showLoansScreen();
}
```
*Disadvantages*: Massive binary size, security leaks of unreleased source code, complex runtime toggles.

### Build-Time Generation Architecture (CitizenOne Pattern)
```text
build/modules.yaml
       ↓
tool/generate_modules.dart
       ↓
apps/citizenone_app/lib/generated/enabled_modules.dart
       ↓
Selected Package Imports & AppModule Instances
       ↓
Root GoRouter Assembly & Flutter Build
```

When a module (e.g. `loans`) is omitted from `build/modules.yaml`:
1. `tool/generate_modules.dart` does NOT generate an import statement for `package:loans/loans.dart`.
2. `enabled_modules.dart` does NOT instantiate `LoansModule()`.
3. `createAppRouter(enabledModules)` does NOT register `/loans` routes in `GoRouter`.
4. Dart's compiler excludes unused package classes from compilation.

---

## 6. Environment Flavors vs Business Module Configuration

It is critical to distinguish between **Environment Flavors** and **Business Module Configurations**:

| Dimension | Managed By | Purpose | Examples |
|---|---|---|---|
| **Environment Flavor** | Flutter Build Target (`--flavor`) | Backend URLs, SSL Certificates, Logging Levels, Environment Keys | `dev`, `sit`, `uat`, `preprod`, `prod` |
| **Module Configuration** | YAML file (`build/modules.yaml`) | Enabling/disabling business feature modules per client/market | `agency_banking_only`, `full_suite`, `civic_portal` |

**DO NOT** create exponential matrix combinations of Flutter flavors like `dev_agency_banking_kyc_loans`. Keep environment configuration orthogonal to business module selection.

---

## 7. How to Add a New Feature

To add a new feature (e.g., `Cash Withdrawal`) inside `agency_banking`:

1. Create feature directory under `packages/agency_banking/lib/src/features/cash_withdrawal/`.
2. Implement data layer: `cash_withdrawal_api.dart`, `cash_withdrawal_model.dart`, `cash_withdrawal_repository.dart`.
3. Implement domain layer: `cash_withdrawal_entity.dart`, `submit_cash_withdrawal.dart` (UseCase).
4. Implement presentation layer: `cash_withdrawal_state.dart`, `cash_withdrawal_cubit.dart`, `cash_withdrawal_screen.dart`.
5. Define feature routes in `cash_withdrawal_routes.dart`:
   ```dart
   final List<RouteBase> cashWithdrawalRoutes = [
     GoRoute(
       path: '/agency-banking/cash-withdrawal',
       builder: (context, state) => ...,
     ),
   ];
   ```
6. Add `cashWithdrawalRoutes` to `AgencyBankingModule.routes` in `agency_banking_module.dart`.

---

## 8. How to Add a New Business Module

To add a completely new business module (e.g. `payments`):

1. Create package directory: `packages/payments/`.
2. Create `pubspec.yaml` with dependencies on `core`, `design_system`, `flutter_bloc`, `go_router`, `equatable`.
3. Create `packages/payments/lib/src/theme/` for module colors and theme.
4. Implement features following Clean Architecture.
5. Create `PaymentsModule` implementing `AppModule`:
   ```dart
   class PaymentsModule implements AppModule {
     @override
     String get id => 'payments';
     @override
     String get title => 'Payments & Transfers';
     @override
     List<RouteBase> get routes => [...];
     @override
     List<BlocProvider> get providers => [];
   }
   ```
6. Register `payments` in `availableModulesMap` inside `tool/generate_modules.dart`.
7. Add `payments` to `build/modules.yaml` and run `dart run tool/generate_modules.dart`.
8. Add package dependency to `apps/citizenone_app/pubspec.yaml`.

---

## 9. Production & CI/CD Workspace Isolation

While Dart tree-shaking strips unreferenced Dart code, monorepos containing native code plugins (e.g. iOS Pods or Android Gradle dependencies) in unused packages may still link native assets into binaries if referenced directly in `pubspec.yaml`.

### Recommended CI/CD Workspace Isolation Strategy
For strict binary isolation in production releases:
1. CI script reads `build/modules.yaml`.
2. CI creates a temporary build directory containing `apps/citizenone_app`, `packages/core`, `packages/design_system`, and ONLY the selected module package folders.
3. CI rewrites `apps/citizenone_app/pubspec.yaml` to include only the selected module package path dependencies.
4. CI executes `flutter pub get` and `flutter build apk / ipa`.

This guarantees 100% binary isolation at both Dart compile-time and native link-time.
