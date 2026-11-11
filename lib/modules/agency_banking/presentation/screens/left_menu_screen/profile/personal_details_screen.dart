import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/BaseScreen/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/agency_banking/utils/DashedBorder.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/UICleanupHelper.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final CommAgentDetails agentDetailsResponse;
  const PersonalDetailsScreen({required this.agentDetailsResponse});

  @override
  _PersonalDetailsScreen createState() => _PersonalDetailsScreen();
}

class _PersonalDetailsScreen extends State<PersonalDetailsScreen> {
  Color myHexColor = const Color(0xff5c7d33);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Personal Details",
      ),
      body: Container(
        color: AppColors.bgColorScreen, // Set background color of the screen
        child: Column(
          children: [
            const SizedBox(height: 30), // Profile Picture
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(
                  'assets/images/profile_image.png'), // Replace with your asset
            ),
            const SizedBox(height: 20), // Personal Details Container
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Personal Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              // Edit logic
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.black),
                            onPressed: () {
                              // Camera logic
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${widget.agentDetailsResponse.agentName}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${widget.agentDetailsResponse.phNo}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Text(
                  //   '${widget.agentDetailsResponse?.headerInfo?.email ?? ''}',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 10), // Saved Addresses Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saved Addresses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      // Handle add new address logic
                    },
                    child: DashedBorder(
                      color: Colors.black,
                      strokeWidth: 1.0,
                      dashLength: 8.0,
                      gapLength: 4.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 10),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: myHexColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'ADD NEW',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
