// // crop_suggestion_item.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../data/model/shgDetails/shgDetailsResp.dart';
// import '../controllers/crop_suggestion_controller.dart';
//
//
// class CropSuggestionItem extends StatelessWidget {
//   final RecommendedCrop? model;
//
//   const CropSuggestionItem({Key? key, required this.model}) : super(key: key);
//
//   static const Color kGreen = Color(0xff4F6F39);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Crop Name
//           _labelValue("Crop Name", model?.cropName ?? ''),
//           const SizedBox(height: 6),
//
//           // Varient
//           _labelValue("Varient", model?.varienty ?? ''),
//           const SizedBox(height: 6),
//
//           // Recommended Radio Buttons
//           Row(
//             children: [
//               const Text(
//                 "Recommended",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Color(0xff71808F),
//                 ),
//               ),
//               const SizedBox(width: 16),
//
//               // Yes Radio Button
//               GestureDetector(
//                 onTap: () {
//                   if (model != null) {
//                     model!.recommended?.value = true;
//                   }
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Radio<bool>(
//                       value: true,
//                       groupValue: model?.recommended?.value ?? false,
//                       onChanged: (bool? value) {
//                         if (model != null && value != null) {
//                           model!.recommended?.value = value;
//                         }
//                       },
//                       activeColor: kGreen,
//                     ),
//                     const Text(
//                       "Yes",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 20),
//
//               // No Radio Button
//               GestureDetector(
//                 onTap: () {
//                   if (model != null) {
//                     model!.recommended?.value = false;
//                   }
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Radio<bool>(
//                       value: false,
//                       groupValue: model?.recommended?.value ?? false,
//                       onChanged: (bool? value) {
//                         if (model != null && value != null) {
//                           model!.recommended?.value = value;
//                         }
//                       },
//                       activeColor: kGreen,
//                     ),
//                     const Text(
//                       "No",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _labelValue(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 3,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Color(0xff71808F),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           flex: 4,
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }