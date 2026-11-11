import 'package:citizenone_app/modules/agency_banking/core/widgets/custom_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/account_specific_repayment_bloc/account_specific_repayment_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/account_specific_repayment_bloc/account_specific_repayment_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/account_specific_repayment_bloc/account_specific_repayment_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/agency_banking/constants/AppStrings.dart';
import 'package:citizenone_app/modules/agency_banking/constants/controllers.dart';
import '../../../data/models/BannerContent.dart';
import '../../../data/models/lms_models/repayment_models/AccSpecificRepaymentRequest.dart';
import '../../../theme/colors/Appcolors.dart';
import '../../../utils/CommDialog.dart';
import '../../../utils/Loader.dart';
import '../../../utils/ResponsiveLeftBanner.dart';
import '../../../utils/UICleanupHelper.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';
import '../../../presentation/screens/Loans/application_form/widgets/labeled_dropdown.dart';
import '../../../presentation/screens/Loans/application_form/widgets/labeled_textField.dart';

class AccountSpecificRepayment extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const AccountSpecificRepayment(
      this.loginResponse, {Key? key, required this.selectedBank})
      : super(key: key);

  @override
  _AccountSpecificRepaymentState createState() =>
      _AccountSpecificRepaymentState();
}

class _AccountSpecificRepaymentState extends State<AccountSpecificRepayment> {
  bool? backPayment;
  TextEditingController backDateController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  String? paymentMode;

  @override
  void initState() {
    super.initState();
    clearAllControllers();
  }

  @override
  void dispose() {
    backDateController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  void clearAllControllers() {
    accountNumberController.clear();
    customerNameController.clear();
    settledAmountController.clear();
    backDateController.clear();
    paymentMode = null;
    backPayment = null;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_loan.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {},
      ),
    ];

    return BlocListener<AccountSpecificRepaymentBloc,
        AccountSpecificRepaymentState>(
      listener: (context, state) {
        if (state is AccountSpecificRepaymentLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is AccountSpecificRepaymentSuccess) {
          showAccountSpecificSuccess(
            context,
            state.accSpecificRepaymentResponse,
            widget.loginResponse,
            widget.selectedBank,
          );
        }
      },
      child: Stack(
        children: [
          _buildScaffoldContent(context, isMobile, banners),
          const GlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildScaffoldContent(
      BuildContext context, bool isMobile, List<BannerContent> banners) {
    return Scaffold(
      appBar: CustomAppBar(title: "Account Specific Repayment"),

      // ===============================
      // FIXED PROCEED BUTTON AT BOTTOM
      // ===============================
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
        child: buildActionButton(
          label: "Proceed",
          onPressed: makePayment,
        ),
      ),

      body: Row(
        children: [
          if (!isMobile) ResponsiveLeftBanner(banners: banners),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: _buildForm(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            AppStrings.accountDetails,
            style: TextStyle(
              color: AppColors.fbLiteDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --------------------------------
        //        LABELED TEXTFIELDS
        // --------------------------------
        LabeledTextField(
          label: "Account Number",
          isMandatory: true,
          controller: accountNumberController,
          maxLength: 15,
        ),

        LabeledTextField(
          label: "Customer Name",
          isMandatory: true,
          controller: customerNameController,
          maxLength: 15,
        ),

        LabeledTextField(
          label: "Settled Amount",
          isMandatory: true,
          controller: settledAmountController,
          keyboardType: TextInputType.number,
          maxLength: 10,
        ),

        const SizedBox(height: 10),

        // --------------------------------
        //       PAYMENT MODE DROPDOWN
        // --------------------------------
        LabeledDropdown<String>(
          label: "Payment Mode",
          isMandatory: true,
          items: const ["CASH", "ACCOUNT"],
          value: paymentMode,
          onChanged: (val) {
            setState(() => paymentMode = val);
          },
        ),

        const SizedBox(height: 16),

        // --------------------------------
        //         BACK DATED RADIO
        // --------------------------------
        Row(
          children: [
            const Text("Is Back Dated?"),
            Radio(
              value: true,
              groupValue: backPayment,
              onChanged: (val) => setState(() => backPayment = val as bool?),
            ),
            const Text("Yes"),
            Radio(
              value: false,
              groupValue: backPayment,
              onChanged: (val) => setState(() => backPayment = val as bool?),
            ),
            const Text("No"),
          ],
        ),

        // --------------------------------
        //            BACK DATE
        // --------------------------------
        if (backPayment == true)
          LabeledTextField(
            label: "Back Date",
            controller: backDateController,
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                backDateController.text =
                    DateFormat('yyyy-MM-dd').format(picked);
              }
            },
          ),

        const SizedBox(height: 70),
      ],
    );
  }

  // ===================================================
  //                 MAKE PAYMENT CALL
  // ===================================================
  void makePayment() {

    if(settledAmountController.text.isEmpty && paymentMode==null)
    {
      showCustomBottomPopup(context, "Please Enter Amount and Select Payment Mode");
      return;
    }
    if(settledAmountController.text.isEmpty)
    {
      showCustomBottomPopup(context, "Please Enter Amount");
      return;
    }
    if(paymentMode==null)
    {
      showCustomBottomPopup(context, "Please Select Payment Mode");
      return;
    }
    AccSpecificRepaymentRequest req = AccSpecificRepaymentRequest();

    req.accountNumber = 'CL260418415';
    req.settledAmt = double.tryParse(settledAmountController.text);
    req.isBackDated = backPayment ?? false;

    try {
      req.backDate = DateFormat('yyyy-MM-dd').parse(backDateController.text);
    } catch (e) {
      req.backDate = null;
    }

    req.paymentMode = paymentMode ?? "CASH";

    context
        .read<AccountSpecificRepaymentBloc>()
        .add(AccountSpecificRepaymentSubmitted(req));
  }
}

