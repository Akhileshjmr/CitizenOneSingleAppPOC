import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../theme/colors/Appcolors.dart';
import '../../../widgets/bottom_navbar.dart';
import 'InsurancePoliciesScreen.dart'; // Adjust import for InsurancePoliciesScreen

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({Key? key}) : super(key: key);

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Insurance'),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: [
                  _buildCategoryCard(
                    title: 'Motor Vehicle',
                    icon: Icons.directions_car,
                    color: Colors.white,
                    onTap: () {
                      // TODO: Implement Motor Vehicle navigation
                    },
                  ),
                  _buildCategoryCard(
                    title: 'Health & Medical',
                    icon: Icons.medical_services,
                    color: Colors.white,
                    onTap: () {
                      // TODO: Implement Health & Medical navigation
                    },
                  ),
                  _buildCategoryCard(
                    title: 'Life & Family Protection',
                    icon: Icons.family_restroom,
                    color: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InsurancePoliciesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCategoryCard(
                    title: 'Agriculture & Farmer',
                    icon: Icons.agriculture,
                    color: Colors.white,
                    onTap: () {
                      // TODO: Implement Agriculture navigation
                    },
                  ),
                  _buildCategoryCard(
                    title: 'Household & Property',
                    icon: Icons.home,
                    color: Colors.white,
                    onTap: () {
                      // TODO: Implement Household navigation
                    },
                  ),
                  _buildCategoryCard(
                    title: 'Travel & Accident',
                    icon: Icons.flight_takeoff,
                    color: Colors.white,
                    onTap: () {
                      // TODO: Implement Travel navigation
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // 🏠 Home → go back to Dashboard
            Navigator.pop(context);
            return;
          }
          if (index == 1) {
            // Already on Insurance → do nothing
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      splashColor: color.withOpacity(0.2),
      highlightColor: color.withOpacity(0.1),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: AppColors.btnBackground,
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}