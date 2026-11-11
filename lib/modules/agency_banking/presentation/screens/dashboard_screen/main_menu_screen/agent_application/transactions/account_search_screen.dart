import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/transaction_details_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constants/AppStrings.dart';
import '../../../../../../constants/ModuleCode.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../data/models/BannerContent.dart';
import '../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../utils/AESEncryption.dart';
import '../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../../../blocs/account_search_bloc/account_search_state.dart';
import '../../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../../customer_application/customer_transaction_setails_screen.dart';
import 'money_transfers/balance_enquiry.dart';

class AccountSearchScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final dynamic itemKey;
  final String transactionType;
  final CommAccountRequest? commAccountRequest;
  final BankOption selectedBank;

  @override
  _AccountSearchScreenState createState() => _AccountSearchScreenState();
  const AccountSearchScreen(
      {required this.loginResponse,
      required this.itemKey,
      required this.transactionType,
      this.commAccountRequest,
      required this.selectedBank});
}

CommAccountRequest accRequest = CommAccountRequest();

class _AccountSearchScreenState extends State<AccountSearchScreen> {
  final Color myHexColor = Color(0xff5c7d33);
  final TextEditingController accountController = TextEditingController();

  void initState() {
    super.initState();
    AppLogger.debug('AccountSearchScreen initState called');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_banner.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Banner CTA clicked');
        },
      ),
    ];
    return BlocProvider<AccountSearchBloc>(
        create: (context) => AccountSearchBloc(AuthService()),
        child: Scaffold(
            appBar: const CustomAppBar(
              title: "CBS Account Search",
            ),
            body: Row(children: [
              //if (!isMobile) ResponsiveLeftBanner(banners: banners),
              Expanded(
                child: BlocConsumer<AccountSearchBloc, AccountSearchState>(
                  listener: (context, state) {
                    if (state is AccountSearchSuccess) {
                      //accRequest = state.accountData;
                      if (widget.itemKey == ModuleCode.balanceEnquiry) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BalanceEnquiryScreen(
                              commAccountRequest: state.commAccountRequest,
                              itemKey: widget.itemKey,
                              transactionType: widget.transactionType,
                              loginResponse: widget
                                  .loginResponse, // Pass backend response data
                              selectedBank: widget.selectedBank,
                            ),
                          ),
                        );
                      } else if (widget.itemKey == ModuleCode.fundTransfer ||
                          widget.itemKey == 'REC_PAY') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerTransactionScreen(
                              searchResponse: state.commAccountRequest,
                              itemKey: widget.itemKey,
                              transactionType: widget.transactionType,
                              commAccountRequest: widget.commAccountRequest,
                              loginResponse: widget.loginResponse,
                              selectedBank: widget
                                  .selectedBank, // Pass backend response data
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionScreen(
                              commAccountRequest: state.commAccountRequest,
                              itemKey: widget.itemKey,
                              transactionType: widget.transactionType,
                              selectedBank: widget.selectedBank,
                              loginResponse: widget
                                  .loginResponse, // Pass backend response data
                            ),
                          ),
                        );
                      }
                    } else if (state is AccountSearchFailure) {
                      showCustomBottomPopup(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: accountController,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Enter Account Number',
                                          counterText: ""),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 1.5,
                                    color: Colors.black,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.search, color: myHexColor),
                                    onPressed: () {
                                      if (accountController.text.isEmpty) {
                                        showCustomBottomPopup(context,
                                            "Account Number is required");
                                        return;
                                      }
                                      String? loggedInAcc = widget.loginResponse
                                          .loginUserInfo.cbs_acc_no;

                                      if (loggedInAcc != null) {
                                        String decrypted =
                                            AESEncryptionService.decrypt(
                                                loggedInAcc);

                                        if (decrypted ==
                                            accountController.text) {
                                          showCustomBottomPopup(context,
                                              "Debit and Credit Accounts should not be same");
                                          return;
                                        }
                                      }
                                      // Directly trigger the API call via Bloc, passing the account number as it is
                                      accRequest = CommAccountRequest();
                                      accRequest.headerInfo =
                                          widget.loginResponse.headerInfo;
                                      accRequest.service_id = "ACC_SEARCH";
                                      accRequest.accountNum =
                                          AESEncryptionService.encrypt(
                                              accountController.text);
                                      context.read<AccountSearchBloc>().add(
                                            AccountSearchSubmitted(accRequest),
                                          );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (state is AccountSearchLoading)
                            Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  },
                ),
              )
            ])));
  }
}
