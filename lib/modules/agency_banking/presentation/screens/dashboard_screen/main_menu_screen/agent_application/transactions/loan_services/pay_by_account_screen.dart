import 'package:citizenone_app/modules/agency_banking/data/models/AbQueryLoanDetails.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../../../../blocs/account_search_bloc/account_search_state.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_state.dart';

class PayByAccountScreen extends StatefulWidget {
  final String transactionType;
  final LoginUserReqResInfo loginResponse;
  final dynamic itemKey;
  final AbQueryLoanDetails? loanSearchResponse;
  PayByAccountScreen(
      {required this.transactionType,
      required this.loginResponse,
      this.itemKey,
      this.loanSearchResponse});

  @override
  _PayByAccountScreenState createState() => _PayByAccountScreenState();
}

class _PayByAccountScreenState extends State<PayByAccountScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController cifIdController = TextEditingController();
  TextEditingController enteredAmount = TextEditingController();
  TextEditingController accountBranchController = TextEditingController();
  TextEditingController accountCurrencyController = TextEditingController();
  TextEditingController loanExRateController = TextEditingController();
  TextEditingController settlementModeController = TextEditingController();
  TextEditingController reversedController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();

    final loanDetails = widget.loanSearchResponse?.loanDetResp;

    // Set CIF ID
    if (loanDetails?.custId != null) {
      cifIdController.text = loanDetails!.custId!;
    }

    // Safely access the first settlement entry if available
    final settlements = loanDetails?.abLoanSettelments;
    if (settlements != null && settlements.isNotEmpty) {
      final settlement = settlements.first;
      reversedController.text = settlement.rvrsd ?? '';
      settlementModeController.text = settlement.stlmod ?? '';
      loanExRateController.text = settlement.exRate?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AccountSearchBloc, AccountSearchState>(
            listener: (context, state) {
              if (state is AccountSearchSuccess) {
                _updateFieldsWithAccountData(state.commAccountRequest);
              } else if (state is AccountSearchFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<WalletSearchBloc, WalletSearchState>(
            listener: (context, state) {
              if (state is WalletSearchSuccess) {
                _updateFieldsWithWalletData(state.commWalletAccountRequest);
              } else if (state is WalletSearchFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: const CustomAppBar(
            title: "Siinqee Agency",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFirstSection(),
                SizedBox(height: 10),
                _buildSecondSection(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fbLiteDark,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _pickContactForSender() async {
    if (await FlutterContacts.requestPermission()) {
      try {
        Contact? contact = await FlutterContacts.openExternalPick();
        if (contact != null && contact.phones.isNotEmpty) {
          String mobileNumber =
              contact.phones.first.number.replaceAll(RegExp(r'\D'), '');
          mobileNumberController.text = mobileNumber;

          if (mobileNumber.length == 9) {
            // final request = CommWalletAccountRequest(
            //   mobileno: mobileNumber,
            //   headerInfo: widget.loginResponse.headerInfo,
            //   moduleCode: widget.itemKey,
            // );
            // senderSearchBloc.add(WalletSearchSubmitted(request));
          }
        }
      } catch (e) {
        AppLogger.error('Error picking contact', e);
      }
    } else {
      AppLogger.warning('Contact permission denied');
    }
  }

  void _handleSearch() {
    if (widget.transactionType == 'Account') {
      CommAccountRequest accountRequest = CommAccountRequest();
      accountRequest.headerInfo = widget.loginResponse.headerInfo;
      accountRequest.accountNum = searchController.text;
      context.read<AccountSearchBloc>().add(
            AccountSearchSubmitted(accountRequest),
          );
    }

    if (widget.transactionType == 'Wallet') {
      CommWalletAccountRequest walletAccountRequest =
          CommWalletAccountRequest();
      walletAccountRequest.headerInfo = widget.loginResponse.headerInfo;
      walletAccountRequest.mobileno = searchController.text;
      walletAccountRequest.moduleCode = widget.itemKey;
      context
          .read<WalletSearchBloc>()
          .add(WalletSearchSubmitted(walletAccountRequest));
    }
  }

  void _updateFieldsWithAccountData(CommAccountRequest response) {
    setState(() {
      customerNameController.text = response.customerName ?? '';
      accountCurrencyController.text = response.accCcy ?? '';
      mobileNumberController.text = response.mobileno ?? '';
      accountBranchController.text = response.branch ?? '';
      //cifIdController.text = response.accountType ?? '';
    });
  }

  void _updateFieldsWithWalletData(CommWalletAccountRequest response) {
    setState(() {
      customerNameController.text = response.customerName ?? '';
      accountCurrencyController.text = response.accCcy ?? '';
      mobileNumberController.text = response.mobileno ?? '';
      accountBranchController.text = response.branch ?? '';
      //cifIdController.text = response.accountType ?? '';
    });
  }

  Widget _buildFirstSection() {
    String searchLabel =
        widget.transactionType == 'Wallet' ? 'Phone Number' : 'Account Number';
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3, // Allocate more space for the text field
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: searchLabel,
                    ),
                  ),
                ),
                SizedBox(
                    width: 10), // Reduce spacing between text field and icons
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    _handleSearch();
                  },
                ),
                if (widget.transactionType == 'Wallet') ...[
                  SizedBox(
                      width:
                          5), // Fine-tuned spacing between search and contact icon
                  IconButton(
                    icon: Image.asset(
                      'assets/images/img.png',
                      height: 30, // Path to your asset image
                      fit: BoxFit
                          .cover, // Optional: Adjust how the image fits within the widget
                    ),
                    onPressed: _pickContactForSender,
                  ),
                ],
              ],
            ),
            TextField(
              controller: accountBranchController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Branch'),
            ),
            TextField(
              controller: accountCurrencyController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Currency'),
            ),
            TextField(
              controller: cifIdController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'CIF Id'),
            ),
            TextField(
              controller: customerNameController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: mobileNumberController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: enteredAmount,
              decoration: InputDecoration(labelText: 'Enter Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondSection() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Loan Settlements',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: AppColors.black),
            TextField(
              controller: loanExRateController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Loan ExRate'),
            ),
            TextField(
              controller: settlementModeController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Settlement Mode'),
            ),
            TextField(
              controller: reversedController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Reversed'),
            ),
          ],
        ),
      ),
    );
  }
}
