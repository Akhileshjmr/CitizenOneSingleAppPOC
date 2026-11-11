import 'dart:convert';

import 'package:citizenone_app/modules/agency_banking/data/models/EstatementEntity.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/TenantDetails.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/MobileRecentTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/MobileServiceSectionCard.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WalletCardSection.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/fund_transfer/account_fund_transfer.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecureStorageHelper.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/dash_board_screen/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/AccountTransHistory.dart';
import '../../../data/models/CommAccountRequest.dart';
import '../../../data/models/CommWalletAccountRequest.dart';
import '../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../data/services/AuthService.dart';
import '../../../utils/CommDialog.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../../utils/Loader.dart';
import '../../../widgets/bottom_navbar.dart';
import '../../../widgets/mobile_custom_tool_bar.dart';
import '../../blocs/account_balance_bloc/account_balance_bloc.dart';
import '../../blocs/account_balance_bloc/account_balance_state.dart';
import '../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../blocs/account_search_bloc/account_search_event.dart';
import '../../blocs/account_search_bloc/account_search_state.dart';
import '../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../blocs/transaction_history/transaction_history_bloc.dart';
import '../../blocs/transaction_history/transaction_history_event.dart';
import '../../blocs/transaction_history/transaction_history_state.dart';
import '../../blocs/wallet_account_balance/wallet_balance_bloc.dart';
import '../../blocs/wallet_account_balance/wallet_balance_state.dart';
import '../insurance_policy_screen/InsuranceScreen.dart';

class DashBoardMobileLayout extends StatefulWidget {
  final LoginUserReqResInfo? firstLoginResponse;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank; // <-- add this
  final List<TenantDetails>? tenants;
  final String? agentPhoneNumber;
  const DashBoardMobileLayout({
    required this.loginResponse,
    required this.selectedBank,
    this.tenants,
    this.firstLoginResponse,
    this.agentPhoneNumber,
  });

  @override
  _DashBoardMobileLayoutState createState() => _DashBoardMobileLayoutState();

  static Future<void> saveLoginData(LoginUserReqResInfo loginResponse) async {
    await SecureStorageHelper.saveLoginResponse(
        jsonEncode(loginResponse.toJson()));
  }

  static Future<void> saveTenants(List<TenantDetails> tenants) async {
    final jsonList = tenants.map((t) => t.toJson()).toList();
    await SecureStorageHelper.saveTenantsList(jsonEncode(jsonList));
  }

  static Future<List<TenantDetails>> loadTenants() async {
    final data = await SecureStorageHelper.getTenantsList();
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((e) => TenantDetails.fromJson(e)).toList();
  }
}

class _DashBoardMobileLayoutState extends State<DashBoardMobileLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? permission;
  Map<String, dynamic>? permissionGiven;
  Map<String, dynamic>? mainMenu;
  final AuthService authService = AuthService();
  List<EstatementEntity> transactions = [];
  late GetLovBloc lovBloc;
  CommAccountRequest commAccountRequest = CommAccountRequest();
  int _currentIndex = 0;
  BankOption? _selectedBank;
  CommWalletAccountRequest commWalletAccountRequest =
      CommWalletAccountRequest();
  List<TenantDetails> tenants = [];
  Map<String, List<String>> transactionMethods = {};
  bool isTransactionMethodsLoaded = false;

  @override
  void initState() {
    super.initState();
    final request = AccountTransHistory()
      ..headerInfo = widget.loginResponse.headerInfo;

    context.read<DashboardTransactionHistoryBloc>().add(
          TransactionHistorySubmitted(request),
        );
    _loadTenants();
    _selectedBank = widget.selectedBank;
    AppLogger.debug(
        'Dashboard initialized for bank: ${_selectedBank?.bankName}');
    permission = widget.loginResponse.loginUserInfo.permission;
    mainMenu = widget.loginResponse.loginUserInfo.permission?['MAIN_MENU'];
    permissionGiven = Map<String, dynamic>.from(permission!)
      ..remove('MAIN_MENU');
    lovBloc = GetLovBloc(authService);

    if (widget.loginResponse.headerInfo.userType == 'RC' ||
        widget.loginResponse.headerInfo.userType == 'MER') {
      CommAccountRequest accountRequest = CommAccountRequest();
      accountRequest.headerInfo = widget.loginResponse.headerInfo;
      accountRequest.service_id = "ACC_SEARCH";
      accountRequest.accountNum =
          widget.loginResponse.headerInfo.cb_account_no ?? "";
      context
          .read<AccountSearchBloc>()
          .add(AccountSearchSubmitted(accountRequest));
    }
  }

  Future<bool> _onBackPressed() async {
    showLogoutDialog(context);
    return false; // ⛔ stop automatic pop
  }

  @override
  Widget build(BuildContext context) {
    /*return WillPopScope(
        onWillPop: _onBackPressed,*/
    return GestureDetector(
        onTap: () {
          // KeyboardUtils.hideKeyboard(); // 👈 hides keyboard globally
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: WillPopScope(
            onWillPop: _onBackPressed,
            child: MultiBlocListener(
              listeners: [
                BlocListener<WalletBalanceBloc, WalletBalanceState>(
                  listener: (context, state) {
                    if (state is WalletBalanceSuccess) {
                      commWalletAccountRequest = state.commWalletAccountRequest;
                    } else if (state is WalletBalanceFailure) {
                      showCustomBottomPopup(context, state.error);
                    }
                  },
                ),
                BlocListener<AccountBalanceBloc, AccountBalanceState>(
                  listener: (context, state) {
                    if (state is AccountBalanceSuccess) {
                      commAccountRequest = state.commAccountRequest;
                    } else if (state is AccountBalanceFailure) {
                      showCustomBottomPopup(context, state.error);
                    }
                  },
                ),
                BlocListener<DashboardTransactionHistoryBloc,
                    TransactionHistoryState>(
                  listener: (context, state) {
                    if (state is TransactionHistorySuccess) {
                      context.read<LoadingCubit>().hide();
                      setState(() {
                        transactions = state.transHistory.eStatementEntities!;
                      });
                    } else if (state is TransactionHistoryFailure) {
                      context.read<LoadingCubit>().hide();
                      // showCustomBottomPopup(context, state.error);
                    }
                  },
                ),
                BlocListener<AccountSearchBloc, AccountSearchState>(
                  listener: (context, state) {
                    if (state is AccountSearchFailure) {
                      showCustomBottomPopup(context, state.error);
                    }
                  },
                ),
              ],
              child: FocusScope(
                canRequestFocus: false, // 🚫 BLOCK ALL FOCUS ON DASHBOARD
                child: Stack(
                  children: [
                    Scaffold(
                      key: _scaffoldKey,
                      drawer: CustomDrawer(
                        loginResponse:
                            widget.firstLoginResponse ?? widget.loginResponse,
                        selectedBank: _selectedBank ?? BankOption(),
                      ),
                      appBar: MobileCustomToolBar(
                        scaffoldKey: _scaffoldKey,
                        isDashboard: true,
                        bankName: _selectedBank?.bankName,
                        bankLogo: _selectedBank?.logoBytes,
                        showMenu: true,
                        showHelpCenter: false,
                        showSearch: false,
                        showLogin: false,
                        showBankOption: true,
                        showLogout: true,
                        loginResponse: widget.loginResponse,
                        tenants: tenants,
                      ),
                      backgroundColor: AppColors.loginBackground, //.bgColorScreen,
                      body: SingleChildScrollView(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Wallet Card
                            WalletCardSection(
                              loginResponse: widget.loginResponse,
                              selectedBank: _selectedBank,
                            ),

                            const SizedBox(height: 16),

                            /// 🔹 Explore Services — flattened into one grid,
                            /// still fully driven by the live permission data.
                            /// Each item keeps its own "was this a money
                            /// section" flag so tap-routing (TransactionMethodBloc
                            /// vs direct navigateToScreen) stays exactly as before.
                            if (permissionGiven != null && mainMenu != null)
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: MobileServiceSectionCard(
                                  sectionTitle: "Explore Services",
                                  // Driven by every section actually granted
                                  // in permissionGiven — MAIN_MENU is only
                                  // consulted for a nicer title, never used
                                  // to filter sections out, so a section
                                  // missing from MAIN_MENU's title map no
                                  // longer silently disappears from the grid.
                                  items: permissionGiven!.keys.expand((sectionKey) {
                                    final sectionValue =
                                        permissionGiven![sectionKey];
                                    if (sectionValue is! Map) return <ServiceItem>[];
                                    final Map<String, dynamic> sectionItems =
                                        Map<String, dynamic>.from(sectionValue);
                                    final String sectionTitle =
                                        mainMenu![sectionKey]?.toString() ??
                                            sectionKey;
                                    final bool isMoneySection = sectionTitle
                                        .toLowerCase()
                                        .contains("money");

                                    return sectionItems.entries.map((item) => (
                                          key: item.key,
                                          label: item.value.toString(),
                                          isMoneySection: isMoneySection,
                                        ));
                                  }).toList(),
                                  loginResponse: widget.loginResponse,
                                  commAccountRequest: commAccountRequest,
                                  lovBloc: lovBloc,
                                  authService: authService,
                                  selectedBank: widget.selectedBank,
                                  themeColor: _selectedBank?.themeColor ??
                                      AppColors
                                          .dashboardIconColor, // ✅ selected bank color
                                  transactionMethods: transactionMethods,
                                  agentPhoneNumber: widget.agentPhoneNumber,
                                ),
                              ),

                            const SizedBox(height: 10),

                            /// 🔹 Recent Transfers
                            BlocBuilder<DashboardTransactionHistoryBloc,
                                TransactionHistoryState>(
                              builder: (context, state) {
                                return MobileRecentTransaction(
                                  transactions: transactions,
                                  loginResponse: widget.loginResponse,
                                  selectedBank: _selectedBank ?? BankOption(),
                                  isLoading: state is TransactionHistoryLoading,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      bottomNavigationBar: BottomNavBar(
                        currentIndex: _currentIndex,
                        onTap: (index) {
                          if (index == 0) {
                            // 🏠 Already on Dashboard
                            setState(() {
                              _currentIndex = 0;
                            });
                            return;
                          }

                          if (index == 1) {
                            // 🛡 Navigate to Insurance
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InsuranceScreen(),
                              ),
                            );
                            return;
                          }

                          if (index == 2) {
                            // 🛡 Navigate to Insurance
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountFundTransfer(
                                    loginResponse: widget.loginResponse,
                                    itemKey: "FT",
                                    transactionType: "Account",
                                    selectedBank: widget.selectedBank),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                    const GlobalLoader(), // overlay always available
                  ],
                ),
              ),
            )));
  }

  void _loadTenants() async {
    tenants = await DashBoardMobileLayout.loadTenants();
    setState(() {});
  }
}
