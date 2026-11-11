import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/utility_payment/ConfirmationScreen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../utils/Loader.dart';
import '../../../utils/UICleanupHelper.dart';
import '../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../blocs/account_search_bloc/account_search_event.dart';
import '../../blocs/account_search_bloc/account_search_state.dart';

class BillerDetailsScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  const BillerDetailsScreen({super.key, required this.loginResponse});

  @override
  State<BillerDetailsScreen> createState() => _BillerDetailsScreenState();
}

class _BillerDetailsScreenState extends State<BillerDetailsScreen> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController cifController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController billerNumberController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  String? selectedBiller;
  final List<String> billers = [
    'TELECOM VANUATU LIMITED',
    'ELECTRICITY BOARD',
    'WATER SUPPLY',
    'GAS COMPANY',
    'INTERNET PROVIDER',
    'MOBILE RECHARGE',
  ];

  bool get allFieldsFilled {
    return accountController.text.isNotEmpty &&
        currencyController.text.isNotEmpty &&
        branchController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        customerController.text.isNotEmpty &&
        selectedBiller != null &&
        billerNumberController.text.isNotEmpty &&
        mobileController.text.isNotEmpty;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers to update the state when text changes
    accountController.addListener(_updateState);
    currencyController.addListener(_updateState);
    branchController.addListener(_updateState);
    cifController.addListener(_updateState);
    amountController.addListener(_updateState);
    customerController.addListener(_updateState);
    billerNumberController.addListener(_updateState);
    mobileController.addListener(_updateState);
  }

  @override
  void dispose() {
    accountController.dispose();
    currencyController.dispose();
    branchController.dispose();
    cifController.dispose();
    amountController.dispose();
    customerController.dispose();
    billerNumberController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSearchBloc, AccountSearchState>(
      listener: (context, state) {
        if (state is AccountSearchLoading) {
          // Show loader
          context.read<LoadingCubit>().show();
        } else if (state is AccountSearchSuccess) {
          context.read<LoadingCubit>().hide();
          // Update your controllers with API response
          accountController.text = state.commAccountRequest.accountNum ?? '';
          currencyController.text = state.commAccountRequest.accCcy ?? '';
          branchController.text = state.commAccountRequest.branch ?? '';
          // cifController.text = state.accountInfo.cifId ?? '';
          customerController.text = state.commAccountRequest.customerName ?? '';
        } else if (state is AccountSearchFailure) {
         showCustomBottomPopup(context, state.error);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Biller Details"),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            double padding = isMobile ? 16 : 32;
            double spacing = isMobile ? 12 : 16;
            double buttonHeight = isMobile ? 40 : 45;
            double fontSize = isMobile ? 14 : 16;

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAccountNumberField(isMobile, fontSize),
                        SizedBox(height: spacing),
                        _buildTextField('Currency', currencyController, isMobile, fontSize,true),
                        SizedBox(height: spacing),
                        _buildTextField('Branch', branchController, isMobile, fontSize,true),
                        // SizedBox(height: spacing),
                        // _buildTextField('CIF Id', cifController, isMobile, fontSize,false),
                        SizedBox(height: spacing),
                        _buildTextField('Amount', amountController, isMobile, fontSize,false),
                        SizedBox(height: spacing),
                        _buildTextField('Customer Name', customerController, isMobile, fontSize,true),
                        SizedBox(height: spacing),
                        DropdownButtonFormField<String>(
                          value: selectedBiller,
                          decoration: InputDecoration(
                            labelText: 'Biller Name',
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          items: billers
                              .map((biller) => DropdownMenuItem(
                            value: biller,
                            child: Text(biller),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBiller = value;
                            });
                          },
                        ),
                        SizedBox(height: spacing),
                        _buildTextField('Biller Number', billerNumberController, isMobile, fontSize,false),
                        SizedBox(height: spacing),
                        _buildTextField('Mobile No.', mobileController, isMobile, fontSize,false),
                        SizedBox(height: spacing * 2),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: allFieldsFilled
                                        ? AppColors.btnBackground
                                        : AppColors.btnBackground.withOpacity(0.4),
                                    textStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: allFieldsFilled
                                      ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConfirmationScreen(
                                          accountNumber: accountController.text,
                                          currency: currencyController.text,
                                          branch: branchController.text,
                                          amount: amountController.text,
                                          customerName: customerController.text,
                                          billerName: selectedBiller!,
                                          billerNumber: billerNumberController.text,
                                          mobileNumber: mobileController.text,
                                        ),
                                      ),
                                    );
                                  }
                                      : null,
                                  child: Text(
                                    'Proceed',
                                    style: TextStyle(
                                      color: allFieldsFilled
                                          ? AppColors.white
                                          : AppColors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.black),
                                    textStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildAccountNumberField(bool isMobile, double fontSize) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: accountController,
            decoration: InputDecoration(
              labelText: 'Account Number',
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          height: 36,
          width: 36,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.btnBackground,
            ),
            onPressed: () {
             CommAccountRequest accRequest=CommAccountRequest();
              accRequest.headerInfo=widget.loginResponse.headerInfo;
              accRequest.accountNum=accountController.text;
              context.read<AccountSearchBloc>().add(
                AccountSearchSubmitted(accRequest),
              );
            },
            child: const Icon(Icons.search, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isMobile, double fontSize, bool readOnly) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      style: TextStyle(fontSize: fontSize),
    );
  }
}
