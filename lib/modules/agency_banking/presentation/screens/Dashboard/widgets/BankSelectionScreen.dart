import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agrinet/app/agrinet_module.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_button.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/partner_drawer.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_search_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../data/models/common_models/HeaderInfo.dart';
import '../../../../data/models/login_models/TenantDetails.dart';
import '../../../../utils/AESEncryption.dart';
import '../../../../utils/Loader.dart';
import '../../../blocs/login_bloc/login_event.dart';
import '../../../blocs/login_bloc/login_state.dart';
import '../../../blocs/organisation_bloc/org_login_bloc.dart';
import '../../../responsive/breakpoints.dart';
import '../dashboard_entry.dart';
import '../dashboard_mobile_layout.dart';
import 'account_desktop_shell.dart';
class BankOption {
  final String? bankName;
  final String? accountNumber;
  final String? logoPath;
  final Color? themeColor;
  final IconData? dashboardIcon;
  final Color? buttonBackground;
  final String? orgCode;
  final Uint8List? logoBytes;

  BankOption({
    this.bankName,
    this.accountNumber,
    this.logoPath,
    this.themeColor,
    this.dashboardIcon,
    this.buttonBackground,
    this.orgCode,
    this.logoBytes,
  });
}

class BankSelectionHelper {
  static const String bankSelectedKey = "isBankSelected";
  static const String selectedBankKey = "selectedBankJson";

  static Future<void> saveTenants(List<TenantDetails> tenants) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tenants.map((t) => t.toJson()).toList();
    await prefs.setString("tenantsList", jsonEncode(jsonList));
  }

  static Future<void> setBankSelected(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(bankSelectedKey, value);
  }

  static Future<bool> isBankSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(bankSelectedKey) ?? false;
  }

  static Future<void> clearBankSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(BankSelectionHelper.bankSelectedKey);
    await prefs.remove(BankSelectionHelper.selectedBankKey);
  }

  static Future<void> saveSelectedBank(BankOption bank) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        selectedBankKey,
        jsonEncode({
          'bankName': bank.bankName,
          'accountNumber': bank.accountNumber,
          'logoBytes': bank.logoBytes,
          'themeColor': bank.themeColor?.value,
          'orgCode': bank.orgCode,
        }));
  }

  static Future<BankOption?> getSelectedBank() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(selectedBankKey);
    if (jsonStr == null) return null;

    final Map<String, dynamic> map = jsonDecode(jsonStr);

    Uint8List? bytes;
    if (map['logoBytes'] != null) {
      bytes = Uint8List.fromList(List<int>.from(map['logoBytes']));
    }

    return BankOption(
      bankName: map['bankName'],
      accountNumber: map['accountNumber'],
      logoBytes: bytes,
      themeColor: map['themeColor'] != null ? Color(map['themeColor']) : null,
      orgCode: map['orgCode'],
    );
  }
}

void clearLocalData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.remove("loginResponse");
  await prefs.remove("selectedBank");
}

class BankSelectionScreen extends StatefulWidget {
  final List<BankOption> accounts;
  final Function(BankOption) onSelected;
  final LoginUserReqResInfo loginResponse;
  final List<TenantDetails> tenants;
  final String? agentPhoneNumber;
  const BankSelectionScreen({
    super.key,
    required this.accounts,
    required this.onSelected,
    required this.loginResponse,
    required this.tenants,
    this.agentPhoneNumber,
  });

  @override
  State<BankSelectionScreen> createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  int? selectedIndex;
  late Map<String, List<TenantDetails>> groupedTenants;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  /// Titles the user has manually collapsed. Empty by default so every
  /// section (each bank/tenant group) starts expanded.
  final Set<String> _collapsedSections = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    groupedTenants = groupTenantsByType(widget.tenants);
  }

  Map<String, List<TenantDetails>> groupTenantsByType(
      List<TenantDetails> tenants) {
    final Map<String, List<TenantDetails>> grouped = {};

    for (var tenant in tenants) {
      String? type;

      try {
        type =
            AESEncryptionService.decrypt(tenant.org_type ?? '').toUpperCase();
      } catch (e) {
        type = tenant.org_type?.toUpperCase();
      }

      final key = (type == null || type.isEmpty) ? "OTHERS" : type;

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(tenant);
    }

    return grouped;
  }

  final Map<String, IconData> sectionIcons = {
    "BANK": Icons.account_balance,
    "INSURANCE": Icons.shield_outlined,
    "MFI": Icons.groups_2_outlined,
    "MNO": Icons.network_cell,
    "OTHERS": Icons.business,
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrgLoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          FocusScope.of(context).unfocus();
          // hideKeyboard();
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }
        if (state is LoginSuccess) {
          FocusScope.of(context).unfocus();
          //hideKeyboard();
          DashBoardMobileLayout.saveTenants(widget.tenants ?? []);
          DashBoardMobileLayout.saveLoginData(state.user);
          final selectedBank = widget.accounts[selectedIndex!];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => buildDashboardEntry(
                  firstLoginResponse: widget.loginResponse,
                  loginResponse: state.user,
                  selectedBank: selectedBank,
                  tenants: widget.tenants,
                  agentPhoneNumber: widget.agentPhoneNumber,
                ),
              ),
              (route) => false,
            );
          });
        } else if (state is LoginFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              if (Breakpoints.isDesktop(width)) {
                return _buildDesktopContent(context);
              }
              if (Breakpoints.isTablet(width)) {
                return ColoredBox(
                  color: AppColors.loginBackground,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: _buildScaffoldContent(context, isTablet: true),
                    ),
                  ),
                );
              }
              return _buildScaffoldContent(context);
            },
          ),
          const GlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildScaffoldContent(BuildContext context, {bool isTablet = false}) {
    /*return WillPopScope(
        onWillPop: () async => false,*/
    return GestureDetector(
        onTap: () {
          // KeyboardUtils.hideKeyboard(); // 👈 ADD HERE
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: _scaffoldKey,
              drawer: PartnerDrawer(loginResponse: widget.loginResponse),
              backgroundColor: AppColors.loginBackground,
              appBar: CustomAppBar(
                title: "Partner",
                titleStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                showBack: false,
                showLogout: false,
                backgroundColor: AppColors.white,
                leadingWidget: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black87,
                      size: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                /*customActions: [
                  IconButton(
                    onPressed: () {
                      // Notification action
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.black87,
                      size: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],*/
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= HEADER =================
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 20,
                          vertical: isTablet ? 24 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Partner",
                            style: TextStyle(
                              fontSize: isTablet ? 26 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Choose assigned partner to access operations",
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ================= SEARCH =================
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
                      child: _buildSearchField(context,
                          height: isTablet ? 56 : 50),
                    ),

                    SizedBox(height: isTablet ? 28 : 20),

                    /// ================= LIST =================
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 32 : 20),
                        children: _buildPartnerSections(),
                      ),
                    ),

                    /// ================= BOTTOM BUTTONS =================
                    Container(
                        padding: EdgeInsets.all(isTablet ? 28 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                title: "Continue",
                                shape: AppButtonShape.rectangle,
                                enabledColor: AppColors.k613AF5,
                                disabledColor: Colors.grey.shade400,
                                textColor: Colors.white,
                                disabledTextColor: Colors.white,
                                isEnabled: selectedIndex != null,
                                fullWidth: true,
                                height: 50,
                                onPressed: selectedIndex == null
                                    ? null
                                    : () => _handleContinue(context),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )));
  }

  Future<void> _handleCancel(BuildContext context) async {
    bool alreadySelected = await BankSelectionHelper.isBankSelected();
    BankOption? lastSelectedBank = await BankSelectionHelper.getSelectedBank();

    if (!context.mounted) return;

    if (alreadySelected && lastSelectedBank != null) {
      // Go back to dashboard with last selected bank
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => buildDashboardEntry(
              loginResponse: widget.loginResponse,
              selectedBank: lastSelectedBank,
              tenants: widget.tenants),
        ),
        (route) => false,
      );
    } else {
      // No previous selection → logout
      await BankSelectionHelper.clearBankSelection();
      clearLocalData();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  void _handleContinue(BuildContext context) {
    final selectedBank = widget.accounts[selectedIndex!];

    // Save bank to preferences
    BankSelectionHelper.setBankSelected(true);
    BankSelectionHelper.saveSelectedBank(selectedBank);

    // Update app theme if needed
    AppColors.setTheme(selectedBank);

    // Login with orgCode of selected bank
    LoginUserReqResInfo loginInfo = LoginUserReqResInfo();
    HeaderInfo headerInfo = widget.loginResponse.headerInfo;
    loginInfo.headerInfo = headerInfo;
    loginInfo.headerInfo.initialAccess = false;
    loginInfo.headerInfo.authorizationToken = AESEncryptionService.encrypt(
        widget.loginResponse.loginUserInfo.jwtToken ?? '');
    loginInfo.headerInfo.orgCode = selectedBank.orgCode ?? '';
    loginInfo.loginUserInfo.userName =
        widget.loginResponse.loginUserInfo.userName;

    context.read<OrgLoginBloc>().add(LoginSubmitted(loginInfo));
  }

  /// Section widgets (each bank/tenant group), shared by the mobile
  /// ListView and the desktop centered card so the filtering logic only
  /// lives in one place.
  List<Widget> _buildPartnerSections() {
    return [
      // _buildKycCard(),
      ...groupedTenants.entries.map((entry) {
        final filteredTenants = entry.value.where((tenant) {
          final index = widget.accounts.indexWhere(
            (acc) => acc.orgCode == tenant.bankcode,
          );

          if (index == -1) return false;

          final account = widget.accounts[index];

          String bankName = '';

          try {
            bankName = AESEncryptionService.decrypt(account.bankName ?? '')
                .toLowerCase();
          } catch (e) {
            bankName = (account.bankName ?? '').toLowerCase();
          }

          return bankName.contains(searchQuery.trim().toLowerCase());
        }).toList();

        if (filteredTenants.isEmpty) return const SizedBox();

        return _buildSectionCard(entry.key, filteredTenants);
      }),
    ];
  }

  Widget _buildSearchField(BuildContext context, {double height = 50}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFDDDDDD),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                  // Any change to the search text invalidates the current
                  // selection; Continue re-enables only once the user taps
                  // an item from the (possibly filtered) list again.
                  selectedIndex = null;
                });
              },
              decoration: const InputDecoration(
                hintText: "Search partners",
                border: InputBorder.none,
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  searchController.clear();
                  searchQuery = "";
                  FocusScope.of(context).unfocus();
                });
              },
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return AccountDesktopScaffold(
      loginResponse: widget.loginResponse,
      activeItem: AccountNavItem.selectPartner,
      pageTitle: "Select Partner",
      // onBack: () => _handleCancel(context),
      showBackButton: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Partner",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.k0F0F0F,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose assigned partner to access operations",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSearchField(context, height: 52),
            const SizedBox(height: 24),
            ..._buildPartnerSections(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    title: "Continue",
                    onPressed: selectedIndex == null
                        ? null
                        : () => _handleContinue(context),
                    fullWidth: true,
                    isEnabled: selectedIndex != null,
                    enabledColor: AppColors.k613AF5,
                    disabledColor: Colors.grey.shade400,
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    shape: AppButtonShape.rectangle,
                    height: 50,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAgriNetCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        try {
          context.read<LoadingCubit>().show();
          await Future.delayed(const Duration(seconds: 3));
          /*AgrinetModule.login(
            username: widget.loginResponse.loginUserInfo.userName ?? '',
            password: 'Test@123');*/
          await AgrinetModule.login(username: 'abhay', password: 'test12');
        } catch (e) {
          debugPrint("AgriNet Login Error: $e");
        } finally {
          if (mounted) {
            context.read<LoadingCubit>().hide();
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            /// ICON BOX
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.agriculture,
                color: Colors.green,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            /// TEXTS
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AgriNet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Access agricultural network services",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKycCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const KYCSearchScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            /// ICON BOX (matches sections)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.verified_user,
                color: Colors.blue,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            /// TEXTS
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "KYC",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manage customer KYC details",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<TenantDetails> tenants) {
    final bool isExpanded = !_collapsedSections.contains(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.kBDBFC4,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= HEADER =================
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _collapsedSections.add(title); // collapse
                } else {
                  _collapsedSections.remove(title); // expand
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "$title Partners",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= EXPANDABLE CONTENT =================
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                ...tenants.map((tenant) {
                  final index = widget.accounts.indexWhere(
                    (acc) => acc.orgCode == tenant.bankcode,
                  );

                  if (index == -1) return const SizedBox();

                  final account = widget.accounts[index];
                  final isSelected = selectedIndex == index;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: isSelected
                              ? AppColors.blue.withOpacity(0.08)
                              : Colors.white,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.grey.shade200,
                                child: account.logoBytes != null &&
                                        account.logoBytes!.isNotEmpty
                                    ? Image.memory(
                                        account.logoBytes!,
                                        width: 45,
                                        height: 50,
                                      )
                                    : const Icon(
                                        Icons.account_balance,
                                        color: Colors.black,
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AESEncryptionService.decrypt(
                                          account.bankName ?? ""),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (tenant.org_type != null)
                                      Text(
                                        AESEncryptionService.decrypt(
                                            tenant.org_type!),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (tenant != tenants.last)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.borderColor,
                        )
                    ],
                  );
                }).toList(),
              ],
            ),
            secondChild: const SizedBox(),
          ),
        ],
      ),
    );
  }
}
