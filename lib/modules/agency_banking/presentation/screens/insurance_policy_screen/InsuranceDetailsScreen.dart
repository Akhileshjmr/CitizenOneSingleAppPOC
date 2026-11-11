import 'package:citizenone_app/modules/agency_banking/core/widgets/custom_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/insurance_policy_screen/form.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors/Appcolors.dart';
import 'InsurancePolicy.dart';

class InsuranceDetailsScreen extends StatelessWidget {
  final InsurancePolicy policy;

  const InsuranceDetailsScreen({required this.policy, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Life Insurance",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Header Card
              _policyHeader(context),

              const SizedBox(height: 20),

              const Text("Medical Test : Required",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              //  requirements
              _buildEligibility(),
              _buildDocuments(),
              _buildBenefits(),
              _buildFees(),
              _buildPremiumIllustration(),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnBackground),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormLayout(),
                      ),
                    );
                  },
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------
  //       UI COMPONENTS

  Widget _policyHeader(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.greyDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance, // Bank icon
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(policy.type,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Coverage"),
                    Text(policy.coverage,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Premium"),
                    Text(policy.premium,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Policy Term"),
                    Text(policy.policyTerm,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Repayment"),
                    Text(policy.repayment,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnBackground),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormLayout(),
                    ),
                  );
                },
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          childrenPadding: const EdgeInsets.all(16),
          children: children,
        ),
      ),
    );
  }

  Widget _buildEligibility() {
    return _sectionCard("Eligibility Criteria", [
      _bullet("Age : 18–65 years"),
      _bullet("Employment : Salaried / Self-employed"),
      _bullet("Min Income : ZMW 10,000 per month"),
      _bullet("Health Condition : No major pre-existing illness"),
      _bullet("Residency : Must be a resident of Zambia"),
    ]);
  }

  Widget _buildDocuments() {
    return _sectionCard("Document Required", [
      _bullet("Identity Proof : NRC / Passport"),
      _bullet("Address Proof : Utility Bill, Rent Agreement"),
      _bullet("Income Proof : Salary slips / Bank statement (last 3 months)"),
      _bullet("Medical Report : Basic health screening certificate"),
    ]);
  }

  Widget _buildBenefits() {
    return _sectionCard("Benefits & Features", [
      _bullet("Death Benefit : Nominee receives full amount"),
      _bullet("Return of Premium : Available in selected plans"),
      _bullet("Accidental Death Rider : Optional add-on"),
      _bullet("Critical Illness Cover : Optional add-on"),
      _bullet("Flexible Premium Payments : Monthly / Quarterly / Yearly"),
      _bullet("Bonus Accruals : As per insurer performance"),
    ]);
  }

  Widget _buildFees() {
    return _sectionCard("Fees & Charges", [
      _bullet("Policy Issuance Fee : ZMW 100 – ZMW 250"),
      _bullet("Rider Charges : 1–2% of base premium"),
      _bullet("Early Surrender Fee : As per policy rules"),
      _bullet("Late Payment Fee : ZMW 10 per delayed premium"),
    ]);
  }

  Widget _buildPremiumIllustration() {
    return _sectionCard("Premium Illustration (Example)", [
      const Text("For a 30-year-old purchasing a ZMW 1,000,000 cover:"),
      const SizedBox(height: 8),
      _bullet("Monthly Premium : ZMW 350"),
      _bullet("Total Premium Paid (20 years) : ZMW 84,000"),
      _bullet("Maturity Benefit : Only for 'Return of Premium' plans"),
      _bullet("Surrender Value : Eligible after 3 years"),
    ]);
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.4), // better line spacing
            ),
          ),
        ],
      ),
    );
  }

  // Widget _bullet(String text) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 5),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Icon(Icons.circle, size: 8),
  //         const SizedBox(width: 5),
  //         Expanded(child: Text(text)),
  //       ],
  //     ),
  //   );
  // }
}
