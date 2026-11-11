import 'package:citizenone_app/modules/agency_banking/data/models/BannerContent.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/application_form_web_layout.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductListRequest.dart';
import '../../../../data/models/lms_models/loan_product_models/GdbVendorProductDetails.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/ResponsiveLeftBanner.dart';
import '../../../blocs/lms_blocs/products-list/products_list_bloc.dart';
import '../../../blocs/lms_blocs/products-list/products_list_event.dart';
import '../../../blocs/lms_blocs/products-list/products_list_state.dart';
import '../corporate_loan/corporate_form_web_layout.dart';

class LoanProductSection extends StatefulWidget {
  final String? selectedSubOption;
  final String? productGroup;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;
  const LoanProductSection(
      {super.key,
      this.selectedSubOption,
      this.productGroup,
      required this.loginResponse,
      required this.selectedBank});

  @override
  State<LoanProductSection> createState() => _LoanProductSectionState();
}

class _LoanProductSectionState extends State<LoanProductSection> {
  String? selectedProductGroup;
  String? selectedProductId;
  String? selectedVendor;
  String? selectedStore;
  List<String> productGroupOptions = [];
  List<String> vendorOptions = [];
  List<String> storeOptions = [];
  // New
  List<GdbVendorProductDetails>? fetchedProductList;

  @override
  void initState() {
    AppLogger.debug('Product list screen initialized');
    AppLogger.debug('Sub option selected');
    AppLogger.debug('Product group loaded');
    super.initState();
    final req = GdbMerchantDisProductListRequest()
      ..productGroupName = widget.productGroup;
    context.read<ProductsListBloc>().add(
          ProductsListSubmitted(req),
        );
  }

  String _getImageForSubOption(String? subOption) {
    switch (subOption) {
      case "Corporate/SME Loan":
        return "assets/images/Corporate Loan.jpg";
      case "Term Deposit":
        return "assets/images/TD.jpg";
      case "Saving Account":
        return "assets/images/saving_account.jpg";
      case "Group Loans":
        return "assets/images/Group Loan.jpg";
      default:
        return "assets/images/Salary Account.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final Map<String, BannerContent> bannerMapping = {
      "Retail Loan": BannerContent(
        imagePath: "assets/images/home_loan.jpg",
        title: "More Loan Options",
        headline: "Fast approvals for your dreams",
        subtitle:
            "We offer education loans, gold loans, and SME financing too. Talk to our experts!.",
        ctaText: "Explore All Loans",
        onCtaPressed: () {
          AppLogger.debug('Home Loan banner pressed');
        },
      ),
      "Term Deposit": BannerContent(
        imagePath: "assets/images/TD.jpg",
        title: "START INVESTING NOW",
        headline: "Earn more from your savings",
        subtitle:
            "Invest today in Deposit and enjoy fixed, risk-free returns with flexible tenure options. Your money, working for you.",
        ctaText: "Explore All Deposits",
        onCtaPressed: () {
          AppLogger.debug('Personal Loan banner pressed');
        },
      ),
      "Saving Account": BannerContent(
        imagePath: "assets/images/saving_account.jpg",
        title: "Grow Your Savings",
        headline: "Secure and guaranteed returns",
        subtitle:
            "Open a savings account to manage your money safely and earn interest. Easy access and secure banking at your fingertips",
        ctaText: "Explore All Account Types",
        onCtaPressed: () {
          AppLogger.debug('Fixed Deposit banner pressed');
        },
      ),
    };

    // Get the correct banner or a default one
    final BannerContent selectedBanner =
        bannerMapping[widget.selectedSubOption] ??
            BannerContent(
              imagePath: _getImageForSubOption(widget.selectedSubOption),
              title: "Welcome",
              headline: "Your financial journey starts here",
              subtitle: "Select a product to get started.",
              ctaText: "Explore Now",
              onCtaPressed: () {
                AppLogger.debug('Default banner pressed');
              },
            );

    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      body: Row(
        children: [
          if (!isMobile) ResponsiveLeftBanner(banners: [selectedBanner]),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  // removed the blue border as requested
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ProductsListBloc, ProductsListState>(
                      builder: (context, state) {
                        // If MFI Deposit -> manually show products
                        if (widget.selectedSubOption == "Term Deposit") {
                          final manualProducts = [
                            {
                              "productId": "Fixed deposit",
                              "productDesc":
                                  "Fixed deposit where the investor deposits a lump sum for a specific period."
                            },
                            {
                              "productId": "Flexi Fixed Deposit",
                              "productDesc":
                                  "Fixed deposit gives you the advantages of both a traditional FD and a demand deposit."
                            },
                            {
                              "productId": "Tax Saving Term Deposits",
                              "productDesc":
                                  "Deposits have a lock-in period of 5 years and allow tax benefits under Section 80C of the Income Tax Act"
                            },
                          ];

                          return _buildProductCard(manualProducts);
                        }
                        if (widget.selectedSubOption == "Saving Account") {
                          final manualProducts = [
                            {
                              "productId": "Regular Savings Account",
                              "productDesc":
                                  "Regular Savings Accounts Offer a secure and straightforward way to save money."
                            },
                            {
                              "productId": "Zero Balance Savings Account",
                              "productDesc":
                                  "Zero Balance Savings with no Minimum Balance requirements"
                            },
                            {
                              "productId": "Salary Account",
                              "productDesc":
                                  "Salary Account are typically opened by employers."
                            },
                          ];

                          return _buildProductCard(manualProducts);
                        }
                        // Otherwise continue with API results
                        if (state is ProductsListLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ProductsListFailure) {
                          return Center(
                            child: Text(
                                "Failed to load products: ${state.error ?? 'Unknown error'}"),
                          );
                        } else if (state is ProductsListSuccess) {
                          final products = state
                                  .gdbMerchantDisProductPurResponse
                                  .productList ??
                              [];
                          if (products.isEmpty) {
                            return const Center(
                                child: Text("No products available"));
                          }

                          // Convert API response to the same format as manual list
                          final productData = products
                              .map((p) => {
                                    "productId": p.productId ?? "Unknown",
                                    "productDesc": p.productDesc ??
                                        "No description available"
                                  })
                              .toList();

                          return _buildProductCard(productData);
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductCard(List<Map<String, String>> products) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < products.length; i++) ...[
              InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  final pid = products[i]["productId"];
                  if (pid != null && pid.isNotEmpty) {
                    if (widget.productGroup == "SME/Corporate TERM LOAN") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CorporateFormWebLayout(
                            selectedProductId: pid,
                            selectedProductGroup: widget.productGroup,
                            selectedSubOption: widget.selectedSubOption,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplicationFormWebLayout(
                            selectedProductId: pid,
                            selectedProductGroup: widget.productGroup,
                            selectedSubOption: widget.selectedSubOption,
                            loginResponse: widget.loginResponse,
                            selectedBank: widget.selectedBank,
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Product ID is missing")),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.circularBorder),
                          color: const Color(0xFFA8C8FE),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (products[i]["productId"]?.substring(0, 2) ?? "NA")
                              .toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.cardTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[i]["productId"] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              products[i]["productDesc"] ??
                                  'No description available',
                              style: const TextStyle(
                                fontSize: 14,
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
              if (i != products.length - 1)
                Divider(
                  color: AppColors.cardTextColor,
                  thickness: 0.5,
                  height: 16,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
