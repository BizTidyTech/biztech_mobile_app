// // ignore_for_file: must_be_immutable

// import 'dart:io' show Platform;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
// import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
// import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
// import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
// import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';

// class UpdateNewAccountView extends StatelessWidget {
//   UpdateNewAccountView({super.key});

//   final controller = Get.put(AuthController());

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.plainWhite,
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimaryColor,
//         title: const Text(
//           "Set up your account",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(30),
//         child: SizedBox(
//           height: size.height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GetBuilder<AuthController>(
//                   init: AuthController(),
//                   builder: (_) {
//                     return Column(
//                       children: [
//                         verticalSpacer(20),
//                         controller.imageFile != null
//                             ? CircleAvatar(
//                                 radius: 80,
//                                 backgroundColor: AppColors.lighterGray,
//                                 backgroundImage:
//                                     FileImage(controller.imageFile!),
//                                 // child: controller.imageFile != null
//                                 //     ? Image.file(
//                                 //         controller.imageFile!,
//                                 //         fit: BoxFit.cover,
//                                 //       )
//                                 //     : const SizedBox.shrink(),
//                               )
//                             : CircleAvatar(
//                                 radius: 80,
//                                 backgroundColor: AppColors.lighterGray,
//                               ),
//                         verticalSpacer(15),
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.getFromGallery();
//                           },
//                           child: Text(
//                             controller.imageFile == null
//                                 ? "SELECT FROM GALLERY"
//                                 : "CHOOSE ANOTHER IMAGE",
//                           ),
//                         ),
//                         verticalSpacer(10),
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.getFromCamera();
//                           },
//                           child: Text(
//                             controller.imageFile == null
//                                 ? "CAPTURE WITH CAMERA"
//                                 : "CAPTURE ANOTHER IMAGE",
//                           ),
//                         ),
//                         verticalSpacer(20),
//                         Text(
//                           controller.errMessage,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ],
//                     );
//                   }),
//               verticalSpacer(20),
//               CustomButton(
//                 child: Text(
//                   'Continue',
//                   style: AppStyles.regularStringStyle(18, AppColors.plainWhite),
//                 ),
//                 onPressed: () {
//                   SystemChannels.textInput.invokeMethod('TextInput.hide');
//                   controller.updateNewUserData(context);
//                 },
//               ),
//               verticalSpacer(10),
//               GetBuilder<AuthController>(
//                 init: AuthController(),
//                 builder: (_) {
//                   return Center(
//                     child: controller.showLoading == true
//                         ? Platform.isAndroid
//                             ? const CircularProgressIndicator()
//                             : const CupertinoActivityIndicator()
//                         : const SizedBox.shrink(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
