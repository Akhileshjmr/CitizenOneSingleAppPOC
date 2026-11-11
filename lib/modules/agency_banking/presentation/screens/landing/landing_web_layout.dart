import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/landing/widgets/CategoryChip.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/web_custom_tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/cards/product_card.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/application_status.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../Loans/application_form/product_list_screen.dart';

class LandingWebLayout extends StatelessWidget {
  final List<Map<String, String>> products;
  final String selectedCategory;
  final void Function(String) onCategorySelected;

  const LandingWebLayout({
    super.key,
    required this.products,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 🔹 AppBar Row
          const WebCustomToolBar(showProfile: false, showLogout: false, showBackArrow: false,),
          // 🔹 Hero Banner
          Stack(
            children: [
              Image.asset(
                "assets/images/home_banner.jpg",
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 40,
                top: 100,
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Digital platforms simplify access to\nboth large and small-value loans\nfor low-income groups through a few steps!",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnBackground,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text("Apply Now", style: TextStyle(color: AppColors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🔹 Category Chips + Application Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    "All", "Loans", "Deposits", "CASA Account", "Islamic", "Services"
                  ].map((category) {
                    return CategoryChip(
                      label: category,
                      selected: selectedCategory == category,
                      onTap: () => onCategorySelected(category),
                    );
                  }).toList(),
                ),
                /*TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ApplicationStatusScreen()),
                    );
                  },
                  child: const Text("Know Your Application Status"),
                ),*/
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Responsive Product Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 900) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 3.4,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductCard(
                      title: product["title"] ?? "",
                      subtitle: product["subtitle"] ?? "",
                      description: product["description"] ?? "",
                      imagePath: product["imagePath"] ?? "assets/images/placeholder.png", // ✅ ensures fallback
                      category: product["category"] ?? "",
                      onTap: () {
                        final productCategory = product['title'] ?? "";
                        const categoryMap = {
                          'Retail Loan': 'MFI Loans',
                          'Corporate/SME Loan': 'SME/Corporate TERM LOAN',
                          'Group Loans': 'MFI Group Loans',
                          'Islamic': 'MFI Loans',
                          'Services': 'MFI Loans',
                        };
                        final productGroup = categoryMap[productCategory] ?? 'MFI Loans';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: const CustomAppBar(
                                title: "Application Process",
                                showBack: true,
                                showLogout: false,
                              ),
                              body: LoanProductSection(
                                selectedSubOption: product['title'] ?? "",
                                productGroup: productGroup,
                                loginResponse: LoginUserReqResInfo(),
                                selectedBank: BankOption(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

