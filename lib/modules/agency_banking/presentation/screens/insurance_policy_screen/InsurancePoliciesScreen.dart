import 'package:citizenone_app/modules/agency_banking/core/widgets/custom_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'InsuranceDetailsScreen.dart';
import 'InsurancePolicy.dart';
import 'form.dart';

class InsurancePoliciesScreen extends StatelessWidget {
  final List<InsurancePolicy> policies = [
    InsurancePolicy(
      name: "Life Secure",
      type: "Life Insurance",
      coverage: "From ZMW 250/month",
      policyTerm: "10 - 25 Years",
      price: "ZMW 500,000",
      premium: "From ZMW 350/month",
      repayment: "Allowed",
    ),
    InsurancePolicy(
      name: "Safe Life Protect",
      type: "Life Insurance",
      coverage: "From ZMW 250/month",
      policyTerm: "10 - 25 Years",
      price: "ZMW 750,000",
      premium: "From ZMW 350/month",
      repayment: "Allowed",
    ),
    InsurancePolicy(
      name: "Future Care",
      type: "Life + Disability",
      coverage: "From ZMW 250/month",
      policyTerm: "10 - 25 Years",
      price: "ZMW 950,000",
      premium: "From ZMW 350/month",
      repayment: "Allowed",
    ),
  ];

   InsurancePoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
       title: "Insurance Policies ",
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Available Offers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            ...policies.map((p) => _policyCard(context, p)).toList(),

            const SizedBox(height: 20),

            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: AppColors.btnBackground),
            //     onPressed: () {},
            //     child: const Text("Apply",style: TextStyle(color: Colors.white),),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _policyCard(BuildContext context, InsurancePolicy policy)
  {
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
                  child: const Icon(
                    Icons.account_balance,   // Bank icon
                    size: 30,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(policy.type, style: const TextStyle(color: Colors.grey)),
                      Text("Coverage : ${policy.coverage}"),
                      Text("Policy Term : ${policy.policyTerm}"),
                    ],
                  ),
                ),
                Text(policy.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.btnBackground),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormLayout(),
                        ),
                      );
                    },
                    child: const Text("Apply",style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InsuranceDetailsScreen(policy: policy),
                        ),
                      );
                    },
                    child: const Text("View Details"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
