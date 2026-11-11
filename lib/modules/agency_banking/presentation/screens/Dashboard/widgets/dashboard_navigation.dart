import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/EKycVerification.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/wallet_registration_file.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';

import '../../../../constants/ModuleCode.dart';
import '../../../../data/models/CommAccountRequest.dart';
import '../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../data/services/AuthService.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/Loader.dart';
import '../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../Loans/account_specific_repayment.dart';
import '../../Loans/application_form/application_form_web_layout.dart';
import '../../Loans/application_form/application_status.dart';
import '../../Loans/customer_specific_repayment.dart';
import '../../Loans/domestic_fund_transfer.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/account_search_screen.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/additional_account_screen.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/loan_services/loan_repayment_screen.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/Cbs_to_wallet (1).dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/fund_transfer/account_fund_transfer.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/fund_transfer/wallet_fund_transfer_screen.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/receive_money_wallet.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/receive_request.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/request_money.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/send_money_screen.dart';
import '../../dashboard_screen/main_menu_screen/agent_application/transactions/wallet_account_search_screen.dart';
import '../../dashboard_screen/main_menu_screen/customer_application/bulk_services.dart';
import '../../dashboard_screen/main_menu_screen/customer_application/customer_transaction_setails_screen.dart';
import '../../dashboard_screen/main_menu_screen/customer_application/recent_transaction_history.dart';
import '../../dashboard_screen/main_menu_screen/customer_application/scan_pay_screen.dart';
import '../../left_menu_screen/history/transaction_history_screen.dart';
import '../../left_menu_screen/profile/profile_screen.dart';
import '../../utility_payment/UtilityPaymentScreen.dart';
import 'BankSelectionScreen.dart';

void _showBottomPopup(
    BuildContext context,
    String itemKey,
    String userType,
    LoginUserReqResInfo loginResponse,
    CommAccountRequest commAccountRequest,
    BankOption selectedBank) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
          top: false, // keep top free, only protect bottom area
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Transaction Type',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                // Account option
                ListTile(
                  leading: Icon(Icons.account_balance,
                      color: AppColors.btnBackground),
                  title: const Center(
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 20, // Adjust the size as needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                  ),
                  // Expand button
                  onTap: () {
                    Navigator.pop(context); // Close the popup
                    // Navigate based on itemKey for Account
                    if (itemKey == ModuleCode.deposit ||
                        itemKey == ModuleCode.withdrawal) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountSearchScreen(
                            loginResponse: loginResponse,
                            itemKey: itemKey,
                            transactionType: 'Account',
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                    if (itemKey == ModuleCode.loanRepayment) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoanRepaymentScreen(
                                    transactionType: 'Account',
                                    loginResponse: loginResponse,
                                    itemKey: itemKey,
                                  )));
                    }
                    if (itemKey == 'RM') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiveMoney(
                              loginResponse: loginResponse,
                              transaction: 'Account',
                              itemKey: itemKey),
                        ),
                      );
                    }
                    if (itemKey == 'SM' && userType != 'RC') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyScreen(
                            loginResponse: loginResponse,
                            transaction: 'Account',
                            itemKey: itemKey,
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                    if (itemKey == 'SM' && userType == 'RC') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransHistory(
                                    loginResponse: loginResponse,
                                    transactionType: 'Account',
                                    itemKey: itemKey,
                                    commAccountRequest: commAccountRequest,
                                    selectedBank: selectedBank,
                                  )));
                    }
                    if (itemKey == ModuleCode.balanceEnquiry) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountSearchScreen(
                            loginResponse: loginResponse,
                            itemKey: itemKey,
                            transactionType: 'Account',
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                    if (itemKey == ModuleCode.fundTransfer ||
                        itemKey == 'REC_PAY') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransHistory(
                            loginResponse: loginResponse,
                            itemKey: itemKey,
                            transactionType: 'Account',
                            commAccountRequest:
                                commAccountRequest, // Pass the successful response
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),
                // Wallet option
                ListTile(
                  leading: Icon(Icons.account_balance_wallet,
                      color: AppColors.btnBackground),
                  title: const Center(
                    child: Text(
                      'Wallet',
                      style: TextStyle(
                        fontSize: 20, // Adjust the size as needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                  ),
                  // Expand button
                  onTap: () {
                    Navigator.pop(context); // Close the popup
                    // Navigate based on itemKey for Account
                    if (itemKey == ModuleCode.deposit ||
                        itemKey == ModuleCode.withdrawal) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletAccountSearch(
                            loginResponse: loginResponse,
                            itemKey: itemKey,
                            transactionType: 'Wallet',
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                    if (itemKey == ModuleCode.loanRepayment) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoanRepaymentScreen(
                                    transactionType: 'Wallet',
                                    loginResponse: loginResponse,
                                    itemKey: itemKey,
                                  )));
                    }
                    if (itemKey == 'RM') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiveMoney(
                            loginResponse: loginResponse,
                            transaction: 'Wallet',
                            itemKey: itemKey,
                          ),
                        ),
                      );
                    }
                    if (itemKey == 'SM' && userType != 'RC') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyScreen(
                            loginResponse: loginResponse,
                            transaction: 'Wallet',
                            itemKey: itemKey,
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                    if (itemKey == 'SM' && userType == 'RC') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransHistory(
                                    loginResponse: loginResponse,
                                    transactionType: 'Wallet',
                                    itemKey: itemKey,
                                    selectedBank: selectedBank,
                                  )));
                    }
                    if (itemKey == ModuleCode.balanceEnquiry) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletAccountSearch(
                            loginResponse: loginResponse,
                            transactionType: 'Wallet',
                            itemKey: itemKey,
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }
                    if (itemKey == ModuleCode.fundTransfer ||
                        itemKey == 'REC_PAY') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransHistory(
                            loginResponse: loginResponse,
                            itemKey: itemKey,
                            transactionType: 'Wallet',
                            selectedBank: selectedBank,
                            // commAccountRequest: state.commAccountRequest, // Pass the successful response
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ));
    },
  );
}

void _showBottomFtPopup(BuildContext context, String itemKey, String userType,
    LoginUserReqResInfo loginResponse, BankOption selectedBank) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
          top: false, // keep top free, only protect bottom area
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Center the header text
                const Center(
                  child: Text(
                    'Transaction Type',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                // Add spacing after the header
                ListTile(
                  leading: Icon(Icons.account_balance_wallet_outlined,
                      color: AppColors.btnBackground),
                  title: const Center(
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 20, // Adjust the size as needed
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 19,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountFundTransfer(
                          loginResponse: loginResponse,
                          itemKey: itemKey,
                          transactionType: "Account",
                          selectedBank: selectedBank,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                    leading: Icon(Icons.account_balance_outlined,
                        color: AppColors.btnBackground),
                    title: const Center(
                      child: Text(
                        'Wallet',
                        style: TextStyle(
                          fontSize: 20, // Adjust the size as needed
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 19,
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the popup
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletFundTransfer(
                            loginResponse: loginResponse,
                            itemKey: itemKey,
                            transactionType: "Wallet",
                            selectedBank: selectedBank,
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ));
    },
  );
}

String getSvgIconPath(String itemKey) {
  switch (itemKey) {
    case 'SM': // Send Money
      return 'assets/icons/send.svg';
    case ModuleCode.deposit: // Deposit
      return 'assets/icons/deposit.svg';
    case ModuleCode.withdrawal: // Withdrawal
      return 'assets/icons/withdraw.svg';
    case ModuleCode.customerCreation: // Customer Creation
      return 'assets/icons/new_account.svg';
    case ModuleCode.fundTransfer: // Fund Transfer
      return 'assets/icons/fund.svg';
    case ModuleCode.requestMoney: // Request Money
      return 'assets/icons/request_money_.svg';
    case 'RM': // Receive Money
      return 'assets/icons/receive.svg';
    case ModuleCode.trustAccount: // Trust account
      return 'assets/icons/trust_account.svg';
    case ModuleCode.balanceEnquiry: // Balance enquiry
      return 'assets/icons/balance_enquiry.svg';
    case ModuleCode.receiveRequest: // Receive Request
      return 'assets/icons/receive_request_.svg';
    case ModuleCode.cbsToWallet: // CBS to Wallet
      return 'assets/icons/top_up_log.svg';
    case ModuleCode.walletToCbs: // Wallet to CBS
      return 'assets/icons/wallet_to_cbs_fund_transfer.svg';
    case ModuleCode.billPayment:
      return 'assets/icons/useful_icons/utility_payment.svg';
    case ModuleCode.accountCreation: // Additional Account
      return 'assets/icons/additional_account.svg';
    case ModuleCode.walletRegistration:
      return 'assets/icons/wallet_registration_.svg';
    case ModuleCode.corporatePayment: // Corporate payment
      return 'assets/icons/corporate_payment__bulk_payment_.svg';
    case 'REC_PAY': // Receive payment
      return 'assets/icons/receive_payment.svg';
    case ModuleCode.retailLoanApplication:
      return 'assets/icons/receive_payment.svg';
    case ModuleCode.domesticFt:
      return 'assets/icons/useful_icons/Transaction.svg';
    case ModuleCode.internationalFt:
      return 'assets/icons/useful_icons/Transaction.svg';
    case ModuleCode.accountRepayment:
      return 'assets/icons/useful_icons/account_specific_repayment.svg';
    case ModuleCode.customerRepayment:
      return 'assets/icons/useful_icons/customer_specific_repayment.svg';
    default:
      return 'assets/icons/wallet_registration_.svg';
  }
}

Future<void> handleNavigation(
  List<String> methods,
  String itemKey,
  BuildContext context,
  String userType,
  LoginUserReqResInfo loginResponse,
  CommAccountRequest commAccountRequest,
  GetLovBloc lovBloc,
  AuthService authService,
  BankOption selectedBank,
  String? agentPhoneNumber,
) async {
  // ✅ ONLY ACCOUNT
  if (methods.length == 1 && methods.contains("ACCOUNT")) {
    await navigateToScreen(
      agentPhoneNumber,
      itemKey,
      context,
      userType,
      loginResponse,
      commAccountRequest,
      lovBloc,
      authService,
      selectedBank,
      transactionType: "Account", // 👈 NEW
    );
  }

  // ✅ ONLY WALLET
  else if (methods.length == 1 && methods.contains("WALLET")) {
    await navigateToScreen(
      agentPhoneNumber,
      itemKey,
      context,
      userType,
      loginResponse,
      commAccountRequest,
      lovBloc,
      authService,
      selectedBank,
      transactionType: "Wallet",
    );
  }

  // ✅ BOTH → POPUP
  else if (methods.contains("ACCOUNT") && methods.contains("WALLET")) {
    _showBottomPopup(context, itemKey, userType, loginResponse,
        commAccountRequest, selectedBank);
  }
}

Future<void> navigateToScreen(
  String? agentPhoneNumber,
  String itemKey,
  BuildContext context,
  String userType,
  LoginUserReqResInfo loginResponse,
  CommAccountRequest commAccountRequest,
  GetLovBloc lovBloc,
  AuthService authService,
  BankOption selectedBank, {
  String? transactionType,
}) async {
  AppLogger.debug('Dashboard navigation: $itemKey');
  switch (itemKey) {
    case ModuleCode.walletToCbs:
      if (userType != 'RC') {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalletToCbsScreen(
              loginResponse: loginResponse,
              itemKey: itemKey,
              selectedBank: selectedBank,
            ),
          ),
        );*/
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerTransactionScreen(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: '',
              commAccountRequest: commAccountRequest,
              userType: userType, // Pass the successful response
              selectedBank: selectedBank,
            ),
          ),
        );
      }
      break;

    case ModuleCode.cbsToWallet:
      if (userType != 'RC') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CbsToWallet(
              loginResponse: loginResponse,
              itemKey: itemKey,
              selectedBank: selectedBank,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerTransactionScreen(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: '',
              commAccountRequest:
                  commAccountRequest, // Pass the successful response
              selectedBank: selectedBank,
            ),
          ),
        );
      }
      break;

    case 'SM':
      _showBottomPopup(context, itemKey, userType, loginResponse,
          commAccountRequest, selectedBank);
      break;

    case ModuleCode.requestMoney:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestMoney(
            loginResponse: loginResponse,
            itemKey: itemKey,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case 'RM':
      _showBottomPopup(context, itemKey, userType, loginResponse,
          commAccountRequest, selectedBank);

      break;

    case ModuleCode.deposit: // Deposit action triggers popup
      if (transactionType == "Account") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSearchScreen(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: 'Account',
              selectedBank: selectedBank,
            ),
          ),
        );
      } else if (transactionType == "Wallet") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WalletAccountSearch(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: 'Wallet',
              selectedBank: selectedBank,
            ),
          ),
        );
      }
      break;

    case ModuleCode.withdrawal:
      if (transactionType == "Account") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSearchScreen(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: 'Account',
              selectedBank: selectedBank,
            ),
          ),
        );
      } else if (transactionType == "Wallet") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WalletAccountSearch(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: 'Wallet',
              selectedBank: selectedBank,
            ),
          ),
        );
      }
      break;

    case ModuleCode.loanRepayment:
      _showBottomPopup(context, itemKey, userType, loginResponse,
          commAccountRequest, selectedBank);
      break;

    case ModuleCode.balanceEnquiry:
      if (transactionType == "Account") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSearchScreen(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: 'Account',
              selectedBank: selectedBank,
            ),
          ),
        );
      } else if (transactionType == "Wallet") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WalletAccountSearch(
              loginResponse: loginResponse,
              itemKey: itemKey,
              transactionType: 'Wallet',
              selectedBank: selectedBank,
            ),
          ),
        );
      }
      break;

    case 'REC_PAY':
      _showBottomPopup(context, itemKey, userType, loginResponse,
          commAccountRequest, selectedBank);

      break;

    case ModuleCode.customerCreation:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ApplicationFormWebLayout(
            selectedProductId: "Regular Savings Account",
            selectedProductGroup: "MFI Loans",
            selectedSubOption: "Saving Account",
            loginResponse: loginResponse,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.fundTransfer:
      if (userType == 'RC' || userType == 'MER') {
        _showBottomPopup(context, itemKey, userType, loginResponse,
            commAccountRequest, selectedBank);
      }
      if (userType == 'CC') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadFileScreen(
                loginResponse: loginResponse,
                itemKey: itemKey, // Pass the successful response
              ),
            ));
      } else if (userType != 'RC' && userType != 'MER') {
        if (transactionType == "Account") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AccountFundTransfer(
                loginResponse: loginResponse,
                itemKey: itemKey,
                transactionType: "Account",
                selectedBank: selectedBank,
              ),
            ),
          );
        } else if (transactionType == "Wallet") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WalletFundTransfer(
                loginResponse: loginResponse,
                itemKey: itemKey,
                transactionType: "Wallet",
                selectedBank: selectedBank,
              ),
            ),
          );
        }
      }
      break;

    case ModuleCode.receiveRequest:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiveRequest(
            loginResponse: loginResponse,
            itemKey: itemKey,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.accountCreation:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdditionalAccountScreen(
            loginResponse: loginResponse,
            itemKey: itemKey,
          ),
        ),
      );
      break;

    case ModuleCode.trustAccount:
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WalletAccountSearch(
                  loginResponse: loginResponse,
                  itemKey: itemKey,
                  selectedBank: selectedBank,
                )),
      );
      break;

    case ModuleCode.corporatePayment:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransHistory(
            loginResponse: loginResponse,
            itemKey: itemKey,
            transactionType: '', // Pass the successful response
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.walletRegistration:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WalletKYCReg(
            loginResponse: loginResponse,
            itemKey: itemKey,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.bulkWalletRegistration:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadFileScreen(
            loginResponse: loginResponse,
            itemKey: itemKey,
          ),
        ),
      );
      break;

    case ModuleCode.customerRepayment:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerSpecificRepayment(
            loginResponse,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.accountRepayment:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountSpecificRepayment(
            loginResponse,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.domesticFt:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DomesticFundTransfer(
            loginResponse: loginResponse,
            itemKey: itemKey,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.internationalFt:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DomesticFundTransfer(
            loginResponse: loginResponse,
            itemKey: itemKey,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.billPayment:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UtilityPaymentScreen(
            loginResponse: loginResponse,
          ),
        ),
      );
      break;

    case ModuleCode.retailLoanApplication:
      context.read<LoadingCubit>().show();
      await LoansModule.initLoans(
        phoneNumber: (agentPhoneNumber ?? '').toString(),
        bankCode: AESEncryptionService.decrypt(selectedBank.orgCode ?? ''),
        themeColor: selectedBank.themeColor ?? AppColors.dashboardIconColor,
      );
      context.read<LoadingCubit>().hide();
      /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: CustomAppBar(
                title: "Application Process",
                showBack: true,
                showLogout: false,
              ),
              body: LoanProductSection(
                selectedSubOption: "Retail Loan",
                productGroup: "MFI Loans",
                loginResponse: loginResponse,
                selectedBank: selectedBank,
              ),
            ),
          ));*/
      break;

    case ModuleCode.applicationStatus:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApplicationStatusScreen(
            loginResponse: loginResponse,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;

    case ModuleCode.kycRegistration:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EKYCRegistration(
            loginResponse: loginResponse,
            selectedBank: selectedBank,
          ),
        ),
      );
      break;
    default:
      AppLogger.warning('No screen available for itemKey: $itemKey');
  }
}

int selectedIndex = 0; // Track the current selected index
void onItemTapped(int index, BuildContext context,
    LoginUserReqResInfo loginResponse, BankOption selectedBank) {
  if (index == 0) {
    // Stay on the same screen (Home)
  } else if (index == 1) {
    if (loginResponse.headerInfo.userType == 'RC' ||
        loginResponse.headerInfo.userType == 'MER') {
      // Navigate to ScanScreen for RC users
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScanPayScreen(
                  loginResponse: loginResponse,
                  itemKey: ModuleCode.fundTransfer,
                  selectedBank: selectedBank,
                )),
      );
    } else {
      // Navigate to ProfileScreen for non-RC users
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(loginResponse: loginResponse)),
      );
    }
  } else if (index == 2) {
    if (loginResponse.headerInfo.userType == 'RC' ||
        loginResponse.headerInfo.userType == 'MER') {
      // Navigate to ScanScreen for RC users
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(loginResponse: loginResponse)),
      );
    } else {
      // Navigate to ProfileScreen for non-RC users
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryScreen(
                  loginResponse: loginResponse,
                  selectedBank: selectedBank,
                )),
      );
    }
  }
}
