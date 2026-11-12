#!/usr/bin/env bash
# CitizenOne SuperApp CI Quality Gate Pipeline (Phase 3)
# Executes all automated architectural, analysis, and test quality gates.

set -e

if [ -d "/Users/akhilesh/development/flutter_3.24.3/bin" ]; then
  export PATH="/Users/akhilesh/development/flutter_3.24.3/bin:$PATH"
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}   🛡️  CitizenOne SuperApp: Automated CI Quality Gates      ${NC}"
echo -e "${BLUE}============================================================${NC}"
START_TIME=$(date +%s)

# Gate 1: Boundary & Encapsulation Enforcement
echo -e "\n${BLUE}[GATE 1/4] Architectural Boundary Audit${NC}"
dart run tool/verify_boundaries.dart --json
echo -e "${GREEN}✔ Gate 1 Passed: 0 architectural boundary violations.${NC}"

# Gate 2: Static Analysis
echo -e "\n${BLUE}[GATE 2/4] Static Code Quality & Analysis${NC}"
dart analyze --no-fatal-warnings lib
echo -e "${GREEN}✔ Gate 2 Passed: 0 compilation or analysis errors.${NC}"

# Gate 3: Test Suite
echo -e "\n${BLUE}[GATE 3/4] Unit & Widget Automated Test Suite${NC}"
flutter test
echo -e "${GREEN}✔ Gate 3 Passed: 100% test pass rate.${NC}"

# Gate 4: Build Verification
echo -e "\n${BLUE}[GATE 4/4] Android Debug APK Compilation Verification${NC}"
flutter build apk --debug --android-skip-build-dependency-validation
echo -e "${GREEN}✔ Gate 4 Passed: Debug APK compiled successfully.${NC}"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo -e "\n${GREEN}============================================================${NC}"
echo -e "${GREEN}   ✅ ALL PHASE 3 CI QUALITY GATES PASSED (Time: ${ELAPSED}s)      ${NC}"
echo -e "${GREEN}============================================================${NC}"
exit 0

