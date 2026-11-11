import 'package:citizenone_app/modules/agency_banking/constants/AppStrings.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/labeled_dropdown.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/labeled_textField.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/constants/controllers.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../data/models/BannerContent.dart';
import '../../../data/models/lms_models/repayment_models/L2lLoanRepayRequest.dart';
import '../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../theme/colors/Appcolors.dart';
import '../../../utils/CommDialog.dart';
import '../../../utils/Loader.dart';
import '../../../utils/ResponsiveLeftBanner.dart';
import '../../../utils/UICleanupHelper.dart';
import '../../blocs/lms_blocs/cust_specific_repayment/cust_specific_repayment_bloc.dart';
import '../../blocs/lms_blocs/cust_specific_repayment/cust_specific_repayment_event.dart';
import '../../blocs/lms_blocs/cust_specific_repayment/cust_specific_repayment_state.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';

class CustomerSpecificRepayment extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const CustomerSpecificRepayment(
      this.loginResponse, {Key? key, required this.selectedBank})
      : super(key: key);

  @override
  _CustomerSpecificRepaymentState createState() =>
      _CustomerSpecificRepaymentState();
}

class _CustomerSpecificRepaymentState extends State<CustomerSpecificRepayment> {
  final Color myHexColor = const Color(0xff5c7d33);
  bool? repaymentOrder;
  bool? isBackDatePayment;
  String? paymentMode;

  final TextEditingController customerNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clearAllControllers();
  }

  @override
  void dispose() {
    customerNumberController.dispose();
    super.dispose();
  }

  void clearAllControllers() {
    customerNamesController.clear();
    amountPaidController.clear();
    paymentMode = null;
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

    return BlocListener<CustSpecificRepaymentBloc,
        CustSpecificRepaymentState>(
      listener: (context, state) {
        if (state is CustSpecificRepaymentLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is CustSpecificRepaymentSuccess) {
          showCustomerSpecificSuccess(
              context,
              state.casaAccountCreateResponse,
              widget.loginResponse,
              widget.selectedBank);
        }
        else if(state is CustSpecificRepaymentFailure){
          showCustomBottomPopup(context, state.error);
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
      BuildContext context,
      bool isMobile,
      List<BannerContent> banners,
      ) {
    return Scaffold(
      appBar: CustomAppBar(title: "Customer Specific Repayment"),

      // ============================
      //  PROCEED BUTTON FIXED BELOW
      // ============================
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

        // ===============================
        //       LABELED TEXT FIELDS
        // ===============================

        LabeledTextField(
          label: "Customer Number",
          isMandatory: true,
          controller: customerNumberController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          maxLength: 15,
        ),
        LabeledTextField(
          label: AppStrings.customerName,
          isMandatory: false,
          controller: customerNamesController,
          maxLength: 15,
        ),
        LabeledTextField(
          label: AppStrings.settledAmount,
          isMandatory: true,
          controller: amountPaidController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          maxLength: 10,
        ),

        const SizedBox(height: 10),

        // PAYMENT MODE DROPDOWN
        LabeledDropdown<String>(
          label: "Payment Mode",
          isMandatory: true,
          items: const ["CASH", "ACCOUNT"],
          value: paymentMode,
          onChanged: (val) {
            setState(() {
              paymentMode = val;
            });
          },
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  void makePayment() {
    if(amountPaidController.text.isEmpty && paymentMode==null)
    {
      showCustomBottomPopup(context, "Please Enter Amount and Select Payment Mode");
      return;
    }
    if(amountPaidController.text.isEmpty)
      {
        showCustomBottomPopup(context, "Please Enter Amount");
        return;
      }
    if(paymentMode==null)
    {
      showCustomBottomPopup(context, "Please Select Payment Mode");
      return;
    }
    L2lLoanRepayRequest req = L2lLoanRepayRequest();
    req.custCode = "M00200000353";
    req.paymentMode = paymentMode ?? "CASH";
    req.transactionRef = RandomNumberGenerator.generateId("", 9);
    req.paidAmt = double.tryParse(amountPaidController.text);
    req.payFee = 0.0;

    context
        .read<CustSpecificRepaymentBloc>()
        .add(CustSpecificRepaymentSubmitted(req));
  }
}

