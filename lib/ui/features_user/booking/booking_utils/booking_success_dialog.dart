// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
// import 'package:biztidy_mobile_app/tidytech_app.dart';
// import 'package:biztidy_mobile_app/ui/features/booking/booking_controller/booking_controller.dart';
// import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
// import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
// import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
// import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
// import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
// import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';

// showBookingConfirmationDialog() {
//   logger.w("Showing confirmation dialog");
//   try {
//     showDialog(
//       context: NavigationService.navigatorKey.currentContext!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: AppColors.transparent,
//           child: successDialogCard(),
//         );
//       },
//     );
//   } catch (e) {
//     logger.e("Error showing dialog: ${e.toString()}");
//   }
// }

// Widget successDialogCard() {
//   return Builder(
//     builder: (context) {
//       return Container(
//         height: 420,
//         decoration: BoxDecoration(
//           color: AppColors.plainWhite,
//           border: Border.all(color: AppColors.primaryThemeColor),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 25,
//           vertical: 35,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle_rounded,
//               color: AppColors.kPrimaryColor,
//               size: 100,
//             ),
//             verticalSpacer(30),
//             SizedBox(
//               width: screenWidth(context) * 0.5,
//               child: Text(
//                 "You have successfully booked an appointment. Kindly proceed to make a deposit payment to confirm your order.",
//                 textAlign: TextAlign.center,
//                 style: AppStyles.normalStringStyle(15, AppColors.fullBlack),
//               ),
//             ),
//             verticalSpacer(40),
//             CustomButton(
//               width: screenWidth(context) * 0.5,
//               onPressed: () {
//                 context.pop();
//                 context.pop();
//                 context.pop();
//                 context.pop();
//                 Get.put(BookingsController()).goToBookingsListScreen();
//               },
//               buttonText: AppStrings.contineu,
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
