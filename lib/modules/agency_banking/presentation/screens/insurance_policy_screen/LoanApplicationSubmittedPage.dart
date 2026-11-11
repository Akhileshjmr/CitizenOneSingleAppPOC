import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../theme/colors/Appcolors.dart';
import '../../blocs/account_balance_bloc/account_balance_bloc.dart';
import '../../blocs/account_balance_bloc/account_balance_state.dart';
import '../Dashboard/dashboard_screen.dart';
import 'InsurancePoliciesScreen.dart';
import 'InsuranceScreen.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  final String estimatedTime;
  final String referenceNumber;
  final String description;

  const ApplicationSubmittedScreen({
    super.key,
    required this.estimatedTime,
    required this.referenceNumber,
    this.description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard …..',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Loan Application'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              // circular check with glow
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.btnBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      blurRadius: 30,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'Application Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
              ),

              const SizedBox(height: 28),

              // _InfoCard(
              //   icon: Icons.account_balance_rounded,
              //   title: estimatedTime,
              //   subtitle: 'Estimated Processing Time',
              // ),
              //
              // const SizedBox(height: 16),

              _InfoCard(
                icon: Icons.receipt_long_rounded,
                title: referenceNumber,
                subtitle: 'Reference Number',
              ),

              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: hook up Download PDF logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download started (stub)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnBackground,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Download Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // return to dashboard / pop all
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InsuranceScreen()),
                    );

                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) =>  InsurancePoliciesScreen(),
                    //     settings: RouteSettings(name: 'DashboardScreen'),
                    //   ),
                    // );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide.none,
                  ),
                  child: const Text('return to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}