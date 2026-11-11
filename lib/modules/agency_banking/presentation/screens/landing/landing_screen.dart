import 'package:citizenone_app/modules/agency_banking/presentation/responsive/responsive_layout.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/landing/landing_mobile_layout.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/landing/landing_web_layout.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String selectedCategory = "All";

  final List<Map<String, String>> products = [
    {
      "title": "Retail Loan",
      "subtitle": "Fast approvals for your dreams",
      "description":
          "Access instant personal and housing loans with competitive interest rates and simplified digital processing",
      "imagePath": "assets/images/Individual Loan.jpg",
      "category": "Loans"
    },
    {
      "title": "Corporate/SME Loan",
      "subtitle": "Fast approvals for your dreams",
      "description":
          "Expand your business with corporate loans designed for large-scale operations. Fast approval and competitive interest rates",
      "imagePath": "assets/images/Corporate Loan.jpg",
      "category": "Loans"
    },
    {
      "title": "Group Loans",
      "subtitle": "Fast approvals for your dreams",
      "description":
          "Get collective financing for your group’s needs—ideal for self-help groups and joint borrowers. Easy repayment and support-driven",
      "imagePath": "assets/images/Group Loan.jpg",
      "category": "Loans"
    },
    {
      "title": "Term Deposit",
      "subtitle": "Grow your savings",
      "description":
          "Invest once and watch your money grow. Flexible tenures and assured returns with zero market risk.",
      "imagePath": "assets/images/TD.jpg",
      "category": "Deposits"
    },
    {
      "title": "Recurring Deposit",
      "subtitle": "Save monthly, earn more",
      "description":
          "Achieve your goals with small monthly deposits. Enjoy steady interest and secure returns on maturity",
      "imagePath": "assets/images/RD.jpg",
      "category": "Deposits"
    },
    {
      "title": "Saving Account",
      "subtitle": "Step up with right Savings Account",
      "description":
          "Open a savings account to manage your money safely and earn interest. Easy access and secure banking at your fingertips",
      "imagePath": "assets/images/saving_account.jpg",
      "category": "CASA Account"
    },
    {
      "title": "Current Account",
      "subtitle": "Fast approvals for your dreams",
      "description":
          "Designed for daily business needs. Enjoy seamless payments, fund transfers, and cheque handling",
      "imagePath": "assets/images/Current Account.jpg",
      "category": "CASA Account"
    },
    {
      "title": "Salary Account",
      "subtitle": "Exclusive benefits for salaried individuals",
      "description":
          "A hassle-free account to manage your monthly salary. Get instant access, debit card, and exclusive offers",
      "imagePath": "assets/images/Salary Account.jpg",
      "category": "CASA Account"
    },
    {
      "title": "Loans",
      "subtitle": "Exclusive benefits for salaried individuals",
      "description":
          "Get access to a wide range of loans — personal, business, home, and more. Fast approvals with flexible repayment options",
      "imagePath": "assets/images/Loan.jpg",
      "category": "Islamic"
    },
    {
      "title": "Credit Card Request",
      "subtitle": "Enjoy shopping, travel & rewards",
      "description":
          "Get the card that fits your lifestyle. Enjoy cashback, reward points, and contactless payments with zero annual fees",
      "imagePath": "assets/images/Credit card request.jpg",
      "category": "Services"
    },
  ];

  List<Map<String, String>> get filteredProducts {
    if (selectedCategory == "All") return products;
    return products.where((p) => p["category"] == selectedCategory).toList();
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      body: SafeArea(
        child: ResponsiveLayout(
          mobileLayout: LandingMobileLayout(
            products: filteredProducts,
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected,
          ),
          tabletWebLayout: LandingWebLayout(
            products: filteredProducts,
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected,
          ),
        ),
      ),
    );
  }
}
