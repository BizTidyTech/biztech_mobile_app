// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tidytech/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:tidytech/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:tidytech/ui/shared/custom_button.dart';
import 'package:tidytech/ui/shared/loading_widget.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';

class BookingsDetailsScreen extends StatefulWidget {
  const BookingsDetailsScreen({super.key});

  @override
  State<BookingsDetailsScreen> createState() => _BookingsDetailsScreenState();
}

class _BookingsDetailsScreenState extends State<BookingsDetailsScreen> {
  double _durationValue = 1.0, _roomSqFtValue = 100.0;

  final controller = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      init: BookingsController(),
      builder: (_) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: AppBar(
              elevation: 3,
              shadowColor: AppColors.lightGray,
              surfaceTintColor: AppColors.plainWhite,
              backgroundColor: AppColors.plainWhite,
              title: Text(
                AppStrings.bookings,
                style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  inputWidget(
                    titleText: "Location/Landmark name",
                    textEditingController: controller.locationController,
                    hintText: 'Enter your location name',
                  ),
                  inputWidget(
                    titleText: "Location address",
                    textEditingController: controller.addressController,
                    hintText: 'Enter your location address',
                  ),
                  inputWidget(
                    titleText: "Contact phone number",
                    textEditingController: controller.phoneController,
                    hintText: 'Enter the phone number to contact',
                    keyboardType: TextInputType.phone,
                  ),
                  verticalSpacer(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Duration",
                        style:
                            AppStyles.subStringStyle(12, AppColors.fullBlack),
                      ),
                      Text(
                        "${_durationValue.toInt()} hours",
                        style: AppStyles.regularStringStyle(
                            12, AppColors.deepBlue),
                      ),
                    ],
                  ),
                  Slider(
                    value: _durationValue,
                    min: 1.0,
                    max: 6.0,
                    divisions: 5,
                    label: _durationValue.toString(),
                    thumbColor: AppColors.primaryThemeColor,
                    activeColor: AppColors.kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        _durationValue = value;
                      });
                    },
                  ),
                  inputWidget(
                    titleText: "No. of rooms",
                    textEditingController: controller.roomsCountController,
                    hintText: 'How many rooms are to be cleaned?',
                    keyboardType: TextInputType.number,
                  ),
                  verticalSpacer(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Room sq ft",
                        style:
                            AppStyles.subStringStyle(12, AppColors.fullBlack),
                      ),
                      Text(
                        "${_roomSqFtValue.toInt()} sq ft",
                        style: AppStyles.regularStringStyle(
                            12, AppColors.deepBlue),
                      ),
                    ],
                  ),
                  Slider(
                    value: _roomSqFtValue,
                    min: 100.0,
                    max: 1000.0,
                    divisions: 50,
                    label: _roomSqFtValue.toString(),
                    thumbColor: AppColors.primaryThemeColor,
                    activeColor: AppColors.kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        _roomSqFtValue = value;
                      });
                    },
                  ),
                  inputWidget(
                    titleText: "Further information",
                    textEditingController: controller.descriptionController,
                    hintText: 'Enter any additional information',
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                  ),
                  verticalSpacer(15),
                  Center(
                    child: Text(
                      controller.errMessage,
                      style: AppStyles.subStringStyle(13, AppColors.coolRed),
                    ),
                  ),
                  verticalSpacer(10),
                  controller.showLoading == true
                      ? loadingWidget()
                      : CustomButton(
                          width: screenWidth(context) * 0.5,
                          buttonText: "Book now",
                          onPressed: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            controller.attemptToCreateAppointment(
                                context, _durationValue, _roomSqFtValue);
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
