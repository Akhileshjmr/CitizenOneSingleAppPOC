import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/landing/widgets/CategoryChip.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/cards/product_card.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/application_status.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../widgets/mobile_custom_tool_bar.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';
import '../Loans/application_form/product_list_screen.dart';

class LandingMobileLayout extends StatefulWidget {
  final List<Map<String, String>> products;
  final String selectedCategory;
  final void Function(String) onCategorySelected;


  const LandingMobileLayout({
    super.key,
    required this.products,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<LandingMobileLayout> createState() => _LandingMobileLayoutState();
}

class _LandingMobileLayoutState extends State<LandingMobileLayout> {
  int _currentIndex = 0;
  int _currentBannerIndex = 0;

  Widget _buildHeroBanner() {
    return Column(
      children: [
        SizedBox(
          height: 220, // Matches screenshot proportion
          child: PageView(
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/home_banner.jpg",
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay at the bottom
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent, // no tint at top
                            Colors.black12.withOpacity(0.6), // blue fade at bottom
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text + Button
                  Positioned(
                    bottom: 24,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Own your dream home, with best\nhome loans rate!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btnBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            "Apply Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              // Additional slides go here if needed
            ],
          ),
        ),

        // Dots indicator
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentBannerIndex == index ? 8 : 6,
              height: _currentBannerIndex == index ? 8 : 6,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index
                    ? Colors.grey[700]
                    : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: const MobileCustomToolBar(
          showMenu: true,
          showSearch: true,
          showHelpCenter: true,
          showLogin: true,
          showLogout: false,
          isDashboard: false,
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              _buildHeroBanner(),

            const SizedBox(height: 16),

            // Category Chips + Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 12,
                        children: [
                          "All",
                          "Loans",
                          "Deposits",
                          "CASA Account",
                          "Islamic",
                          "Services"
                        ]
                            .map((cat) => CategoryChip(
                          label: cat,
                          selected: widget.selectedCategory == cat,
                          onTap: () => widget.onCategorySelected(cat),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                  /*TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ApplicationStatusScreen()),
                      );
                    },
                    child: const Text("Know Your Application Status"),
                  )*/
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Product Cards
            ...widget.products.map((product) => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ProductCard(
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
              ),
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation here
        },
      ),
    );
  }
}
