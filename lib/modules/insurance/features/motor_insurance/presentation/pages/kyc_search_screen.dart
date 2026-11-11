// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
// import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
// import 'package:citizenone_app/modules/insurance/core/forms/formatters/app_text_field_formatters.dart';
// import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
// import 'package:citizenone_app/modules/insurance/core/utils/snack.dart';
// import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
// import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
// import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
// import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text_field.dart';
// import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
// import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
// import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

// class KycSearchScreen extends StatefulWidget {
//   const KycSearchScreen({super.key});

//   @override
//   State<KycSearchScreen> createState() => _KycSearchScreenState();
// }

// class _KycSearchScreenState extends State<KycSearchScreen> {
//   final _mobileController = TextEditingController();
//   final _nationalIdController = TextEditingController();

//   @override
//   void dispose() {
//     _mobileController.dispose();
//     _nationalIdController.dispose();
//     super.dispose();
//   }

//   void _search() {
//     final mobile = _mobileController.text.trim();
//     final nationalId = _nationalIdController.text.trim();

//     if (mobile.isEmpty && nationalId.isEmpty) {
//       Snack.show(context, message: 'Please enter Mobile Number or National ID');
//       return;
//     }

//     if (mobile.isNotEmpty && nationalId.isNotEmpty) {
//       Snack.show(
//         context,
//         message: 'Search by either Mobile Number or National ID',
//       );
//       return;
//     }

//     if (mobile.isNotEmpty && mobile.length < 9) {
//       Snack.show(context,
//           message: 'Mobile Number should contain at least 9 digits');
//       return;
//     }

//     if (nationalId.isNotEmpty && nationalId.length < 11) {
//       Snack.show(context, message: 'Please enter a valid National ID');
//       return;
//     }

//     context.read<MotorInsuranceBloc>().add(
//           SearchUserEvent(
//             mobileNumber: mobile,
//             nationalId: nationalId,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: const AppStatusBar(
//         title: 'Insurance Details',
//         centerTitle: false,
//         textIconColor: AppColors.black,
//       ),
//       body: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
//         listener: (context, state) {
//           if (state.status == KycUserStatus.notFound) {
//             context.read<MotorInsuranceBloc>().add(ResetFormData());
//             context.push(AppRoutes.noRecordScreen);
//           }
//           if (state.status == KycUserStatus.error) {
//             Snack.show(context,
//                 message: 'Something went wrong. Please try later');
//           }

//           if (state.status == KycUserStatus.loaded) {
//             context.push(AppRoutes.userDetailScreen);
//           }
//         },
//         builder: (context, state) {
//           final isMobile = AdaptiveLayout.isMobile(context);
//           final contentWidth = AdaptiveLayout.contentMaxWidth(context);

//           return SingleChildScrollView(
//             padding: const EdgeInsets.only(bottom: 24),
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: contentWidth),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: AdaptiveLayout.horizontalPadding(context),
//                         vertical: 12,
//                       ),
//                       child: Column(
//                         children: [
//                           _SearchCard(
//                             isLoading: state.status == KycUserStatus.loading,
//                             mobileController: _mobileController,
//                             nationalIdController: _nationalIdController,
//                             onSearch: _search,
//                             isMobile: isMobile,
//                           ),
//                           const SizedBox(height: 28),
//                           _NewCustomerCard(
//                             isMobile: isMobile,
//                             onUpdateManually: () {
//                             context.push(AppRoutes.userDetailScreen);
//                             context.read<MotorInsuranceBloc>().add(ResetFormData());
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _SearchCard extends StatelessWidget {
//   final bool isLoading;
//   final TextEditingController mobileController;
//   final TextEditingController nationalIdController;
//   final VoidCallback onSearch;
//   final bool isMobile;

//   const _SearchCard({
//     required this.isLoading,
//     required this.mobileController,
//     required this.nationalIdController,
//     required this.onSearch,
//     required this.isMobile,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.outline),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.shadowColor,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AppText(
//             'Find Existing Customer',
//             style: AppTextStyle.displaySmall,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//           const SizedBox(height: 12),
//           const AppText(
//             'Enter a Mobile Number or National ID to find an existing customer record.',
//             style: AppTextStyle.bodyLarge,
//             color: AppColors.textPrimary,
//           ),
//           const SizedBox(height: 28),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const AppText(
//                 'Mobile Number',
//                 style: AppTextStyle.bodyLarge,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//               const SizedBox(height: 8),
//               AppTextField(
//                 controller: mobileController,
//                 keyboardType: TextInputType.phone,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 maxLength: 9,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: AppColors.outline,
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     child: AppText(
//                       'OR',
//                       style: AppTextStyle.bodyLarge,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: AppColors.outline,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               const AppText(
//                 'National ID',
//                 style: AppTextStyle.bodyLarge,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//               const SizedBox(height: 8),
//               AppTextField(
//                 controller: nationalIdController,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'National ID is required';
//                   }
//                   if (value.length != 11) {
//                     return 'Please enter a valid National ID';
//                   }
//                   return null;
//                 },
//                 isEnabled: true,
//                 fillColor: AppColors.surface,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(9),
//                   SlashFormatter(),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               AppButton(
//                 text: isLoading ? '' : 'Search',
//                 icon: Icons.search,
//                 isLoading: isLoading,
//                 onPressed: onSearch,
//                 backgroundColor: AppColors.primary,
//                 radius: 12,
//                 height: 40,
//                 textStyle: AppTextStyle.bodyLarge,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NewCustomerCard extends StatelessWidget {
//   final bool isMobile;
//   final VoidCallback onUpdateManually;

//   const _NewCustomerCard({
//     required this.isMobile,
//     required this.onUpdateManually,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.outline),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.shadowColor,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AppText(
//             'New Customer ?',
//             style: AppTextStyle.bodyLarge,
//             fontWeight: FontWeight.w400,
//             color: AppColors.textPrimary,
//           ),
//           const SizedBox(height: 22),
//           AppButton(
//             text: 'Update Manually',
//             icon: Icons.person_add_alt_1,
//             onPressed: onUpdateManually,
//             backgroundColor: AppColors.surface,
//             foregroundColor: AppColors.primary,
//             textColor: AppColors.primary,
//             borderColor: AppColors.primary,
//             variant: AppButtonVariant.outline,
//             radius: 18,
//             height: 40,
//             textStyle: AppTextStyle.bodyLarge,
//           ),
//         ],
//       ),
//     );
//   }
// }
