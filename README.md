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
citizenone/
│
├── apps/
│   └── citizenone_app/             # Main Application Shell & App Router
│
├── packages/
│   ├── core/                       # Shared Http ApiClient, AppModule contract, Auth/Security
│   ├── design_system/              # Material 3 generic UI components & theme tokens
│   │
│   ├── citizen_one/                # Business Module Package
│   ├── agency_banking/             # Business Module Package
│   ├── kyc/                        # Business Module Package
│   ├── loans/                      # Business Module Package
│   └── insurance/                  # Business Module Package
│
├── build/
│   └── modules.yaml                # Build configuration file selecting enabled modules
│
├── tool/
│   └── generate_modules.dart       # Code generation script for active modules
│
├── docs/
│   └── architecture.md             # In-depth architectural specification
│
├── melos.yaml                      # Monorepo management configuration
├── pubspec.yaml                    # Root workspace pubspec
└── README.md                       # Main documentation
```

---

## 4. Why Modules Are Local Packages

1. **Strict Dependency Boundaries**: Keeps code modular. Core or Design System cannot accidentally import code from a business module.
2. **Independent Testability**: Every business module package can be tested in isolation with `flutter test` without compiling the full application.
3. **Build-Time Selectivity**: Allows selecting which package entrypoints to import in `enabled_modules.dart`. Unused package code is eliminated during compilation.
4. **Reusability across Multiple App Targets**: Multiple app shells (e.g., Agent App vs Consumer App) can compose different combinations of the same business module packages.

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
