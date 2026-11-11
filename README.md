# CitizenOne Modular Flutter Architecture (Bloc/Cubit POC)

A complete, runnable **Flutter modular architecture POC** for **CitizenOne** utilizing `flutter_bloc` / `cubit` state management, `go_router` navigation, `equatable`, Material 3, local Dart/Flutter packages, and build-time YAML module selection via code generation.

---

## 1. Quick Start

### Step 1: Install Dependencies
Run `flutter pub get` in the main app directory or use `melos bootstrap` / `dart pub get` at root:
```bash
flutter pub get
```

### Step 2: Generate Enabled Modules Registry
Run the Dart module generator script:
```bash
dart run tool/generate_modules.dart
```

### Step 3: Run the Application
Run the Flutter app target:
```bash
cd apps/citizenone_app
flutter run
```

---

## 2. Business Modules Overview

The monorepo contains 5 independently structured business modules:

| Module Package | Title | Primary Features | Module ID |
|---|---|---|---|
| `packages/citizen_one` | **Citizen One** | Government e-Services, Digital ID Renewal, Utility Payments | `citizen_one` |
| `packages/agency_banking` | **Agency Banking** | Agent Operations, Cash Deposit, Cash Withdrawal, Transactions | `agency_banking` |
| `packages/kyc` | **KYC** | Identity Document Upload, KYC Verification Status | `kyc` |
| `packages/loans` | **Loans** | Micro-Loans Application, Repayment Calculator | `loans` |
| `packages/insurance` | **Insurance** | Policy Subscription, Health & Micro-Crop Protection | `insurance` |

---

## 3. Repository Architecture

```text
CitizenOneApp/
│
├── lib/
│   ├── main.dart                   # Application bootstrap & runtime environment setup
│   ├── app.dart                    # Root MaterialApp & global theme configuration
│   ├── app_router.dart             # Root GoRouter with declarative route auth guards
│   │
│   ├── core/                       # Shared platform infrastructure (ApiClient, AppEnv, Auth, Logging)
│   ├── design_system/              # Central design tokens, typography, and reusable UI atoms/molecules
│   │
│   ├── modules/                    # Pluggable business modules (Clean Architecture slices)
│   │   ├── common/                 # Civic services, portal auth, performance yield
│   │   ├── agency_banking/         # Agent operations, cash deposit, dashboard
│   │   ├── kyc/                    # Identity document verification & status
│   │   ├── loans/                  # Micro-loan application & eligibility
│   │   └── insurance/              # Policy subscription & claims
│   │
│   └── generated/
│       └── enabled_modules.dart    # Build-time generated active module registry
│
├── build/
│   └── modules.yaml                # Build configuration file selecting enabled modules
│
├── tool/
│   ├── generate_modules.dart       # Code generation CLI with canonical ID deduplication
│   └── verify_boundaries.dart      # Static boundary audit tool enforcing layer rules
│
└── test/                           # 100% passing unit, widget, and architecture tests
```

---

## 4. Modular Structure & Future Package Scalability

The project is structured as a **Modular Architecture** optimized for developer ergonomics, high performance, and rapid onboarding:

1. **Simplicity & Zero Tooling Overhead**: No complex monorepo tooling (like Melos) or local package path symlinks are required. Any new developer can clone and run `flutter run` immediately.
2. **Strict Boundary Enforcement**: Architectural boundary rules (Rule 1: Zero Inter-Module Imports; Inverted Core/Design-System Dependencies) are strictly enforced by automated CI tooling via `dart run tool/verify_boundaries.dart`.
3. **Build-Time Selectivity**: Modules excluded from `build/modules.yaml` are not imported or instantiated in `enabled_modules.dart`, allowing Dart's static compiler to tree-shake unused code from release builds.
4. **Future Multi-Package Extraction**: Because each module under `lib/modules/` adheres to Clean Architecture and communicates strictly through the `AppModule` interface and path URIs, migrating any module into an isolated Flutter package (`packages/<module_name>`) later requires zero architectural refactoring.

---

## 5. Module vs Feature Architecture

- **Module**: Represents a full domain or product vertical (e.g., `agency_banking`). Contains multiple feature slices, module theme, and route registration.
- **Feature**: Represents a specific user workflow slice inside a module (e.g. `cash_deposit` inside `agency_banking`). Follows Clean Architecture (`data`, `domain`, `presentation`, `routes`).

### Clean Feature Layering:
```text
cash_deposit/
├── data/
│   ├── api/
│   ├── models/
│   ├── datasources/
│   └── repository/
├── domain/
│   ├── entities/
│   └── usecases/
├── presentation/
│   ├── cubit/
│   ├── screens/
│   └── widgets/
└── routes/
```

### Clean Architecture Execution Flow:
```text
Screen -> Cubit / Bloc -> UseCase -> Repository -> API -> Core ApiClient
```

---

## 6. Build Configurations (Build A, B, C, D)

Build configurations are controlled via `build/modules.yaml`.

### Build A (Citizen One Only)
`build/modules.yaml`:
```yaml
modules:
  - citizen_one
```
Generated Routes: `/`, `/citizen-one`

### Build B (Agency Banking Only)
`build/modules.yaml`:
```yaml
modules:
  - agency_banking
```
Generated Routes: `/`, `/agency-banking`, `/agency-banking/cash-deposit`

### Build C (Citizen One + Agency Banking)
`build/modules.yaml`:
```yaml
modules:
  - citizen_one
  - agency_banking
```
Generated Routes: `/`, `/citizen-one`, `/agency-banking`, `/agency-banking/cash-deposit`

### Build D (Full Suite - Default)
`build/modules.yaml`:
```yaml
modules:
  - citizen_one
  - agency_banking
  - kyc
  - loans
  - insurance
```
Generated Routes: `/`, `/citizen-one`, `/agency-banking`, `/agency-banking/cash-deposit`, `/kyc`, `/loans`, `/insurance`

To apply any configuration:
```bash
# Edit build/modules.yaml, then run:
dart run tool/generate_modules.dart
```

---

## 7. How to Add a New Feature

To add `Cash Withdrawal` inside `agency_banking`:

1. Create `packages/agency_banking/lib/src/features/cash_withdrawal/`.
2. Add Clean Architecture layers (`data`, `domain`, `presentation`, `routes`).
3. Define feature routes in `cash_withdrawal_routes.dart`.
4. Append `cashWithdrawalRoutes` to `AgencyBankingModule.routes` in `agency_banking_module.dart`.

---

## 8. How to Add a New Business Module

To add `payments`:

1. Create `packages/payments/` with `pubspec.yaml`.
2. Implement features under `packages/payments/lib/src/features/`.
3. Create `PaymentsModule` implementing `AppModule`.
4. Add `payments` entry to `availableModulesMap` in `tool/generate_modules.dart`.
5. Add `payments` to `build/modules.yaml` and run `dart run tool/generate_modules.dart`.

---

## 9. Monorepo Commands & Verification

### Generate Modules
```bash
dart run tool/generate_modules.dart
```
With custom config:
```bash
dart run tool/generate_modules.dart --config=build/modules.yaml
```

### Run All Unit & Widget Tests
```bash
flutter test
```

### Run Static Analysis
```bash
flutter analyze
```

### Run Code Formatting
```bash
dart format .
```

---

## 10. Limitations & Production CI/CD Recommendations

> [!NOTE]
> A monorepo containing all packages in Git does not automatically remove unreferenced source files from disk, but Dart's static compiler excludes unused module imports in `enabled_modules.dart`.
> 
> **Production CI Recommendation**: For strict binary/native dependency isolation, CI pipelines should create a clean build workspace containing only `apps/citizenone_app`, `core`, `design_system`, and the explicitly selected module package folders before invoking `flutter build`.
