import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/CustomDrawer.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/CustomSidebar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/DashboardMobileLayout.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebDashboardLayout.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebRecentTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebDashboardTopBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/ModuleCode.dart';
import '../../../data/models/AccountTransHistory.dart';
import '../../../data/models/CommAccountRequest.dart';
import '../../../data/models/CommWalletAccountRequest.dart';
import '../../../data/models/EstatementEntity.dart';
import '../../../data/services/AuthService.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../blocs/account_search_bloc/account_search_state.dart';
import '../../blocs/chatbot_bloc/chatbot_bloc.dart';
import '../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../blocs/transaction_history/transaction_history_bloc.dart';
import '../../blocs/transaction_history/transaction_history_event.dart';
import '../../blocs/transaction_history/transaction_history_state.dart';
import '../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../blocs/wallet_account_search/wallet_account_search_state.dart';
import '../chatbot/Chatbot.dart';

class DashboardWebLayout extends StatefulWidget {
  @override
  _DashboardWebLayoutState createState() => _DashboardWebLayoutState();
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const DashboardWebLayout(
      {required this.loginResponse, required this.selectedBank});
}

class _DashboardWebLayoutState extends State<DashboardWebLayout> {
  Map<String, dynamic>? permission;
  Map<String, dynamic>? permissionGiven;
  Map<String, dynamic>? mainMenu;
  final AuthService authService = AuthService();
  List<EstatementEntity> transactions = [];
  CommAccountRequest commAccountRequest = CommAccountRequest();
  String? bal;
  String? accountNumber;
  late GetLovBloc lovBloc;

  @override
  void initState() {
    super.initState();
    permission = widget.loginResponse.loginUserInfo.permission;
    mainMenu = widget.loginResponse.loginUserInfo.permission?['MAIN_MENU'];
    permissionGiven = Map<String, dynamic>.from(permission!)
      ..remove('MAIN_MENU');
    lovBloc = GetLovBloc(authService);

    // wallet balance request
    CommWalletAccountRequest request = CommWalletAccountRequest();
    request.mobileno = widget.loginResponse.headerInfo.userName;
    request.headerInfo = widget.loginResponse.headerInfo;
    request.moduleCode = ModuleCode.balanceEnquiry;
    context.read<WalletSearchBloc>().add(WalletSearchSubmitted(request));

    // transaction history request
    AccountTransHistory transactionHistory = AccountTransHistory();
    transactionHistory.headerInfo = widget.loginResponse.headerInfo;
    context.read<DashboardTransactionHistoryBloc>().add(
          TransactionHistorySubmitted(transactionHistory),
        );
  }

  @override
  Widget build(BuildContext context) {
    // On web, always keep the sidebar/desktop dashboard — never fall back
    // to the phone-style burger menu + stacked layout just because the
    // browser window has been resized narrow. That fallback still applies
    // to native (non-web) tablets in the 600-799px range.
    bool isMobile = !kIsWeb && MediaQuery.of(context).size.width < 800;

    return MultiBlocListener(
      listeners: [
        BlocListener<WalletSearchBloc, WalletSearchState>(
          listener: (context, state) {
            if (state is WalletSearchSuccess) {
              setState(() {
                bal = state.commWalletAccountRequest.availabeBal;
                accountNumber = state.commWalletAccountRequest.accountNum;
              });
            } else if (state is WalletSearchFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<DashboardTransactionHistoryBloc, TransactionHistoryState>(
          listener: (context, state) {
            if (state is TransactionHistorySuccess) {
              setState(() {
                transactions = state.transHistory.eStatementEntities ?? [];
              });
            } else if (state is TransactionHistoryFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<AccountSearchBloc, AccountSearchState>(
          listener: (context, state) {
            if (state is AccountSearchSuccess) {
              setState(() {
                commAccountRequest = state.commAccountRequest;
              });
            } else if (state is AccountSearchFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bgColorScreen,
        drawer: isMobile
            ?
//_buildDrawer(context)
            CustomDrawer(
                loginResponse: widget.loginResponse,
                selectedBank: widget.selectedBank,
              )
            : null,
        appBar: isMobile
            ? AppBar(
                title: const Text("Dashboard"),
                backgroundColor: Colors.blue,
              )
            : null,
        body: Row(
          children: [
            if (!isMobile)
              Container(
                width: 220,
                color: Colors.white,
                child: CustomSidebar(
                  loginResponse: widget.loginResponse,
                  selectedBank: widget.selectedBank,
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  if (!isMobile) const WebDashboardTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: isMobile
                          ? DashboardMobileLayout(
                              loginResponse: widget.loginResponse,
                              commAccountRequest: commAccountRequest,
                              lovBloc: lovBloc,
                              authService: authService,
                              transactions: transactions,
                            )
                          : WebDashboardLayout(
                              loginResponse: widget.loginResponse,
                              commAccountRequest: commAccountRequest,
                              lovBloc: lovBloc,
                              authService: authService,
                              transactions: transactions,
                              recentTransfersSection: (txns) =>
                                  RecentTransfersSection(
                                      transactions: transactions,
                                      loginResponse: widget.loginResponse,
                                      selectedBank: widget.selectedBank),
                            ),

                      // pass your builder
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ChatbotBloc(authService),
                  child: const ChatbotScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
