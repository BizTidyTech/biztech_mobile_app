import 'package:biztidy_mobile_app/ui/features_admin/admin_booking/admin_booking_controller/admin_bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_booking/widgets/admin_booking_card.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class AdminBookingsListScreen extends StatefulWidget {
  const AdminBookingsListScreen({super.key});

  @override
  State<AdminBookingsListScreen> createState() =>
      _AdminBookingsListScreenState();
}

class _AdminBookingsListScreenState extends State<AdminBookingsListScreen> {
  final controller = Get.put(AdminBookingsController());

  void optInNotification() async {
    await OneSignal.User.pushSubscription.optIn();
  }

  @override
  void initState() {
    super.initState();
    controller.fetchAllBooking();
    optInNotification();
  }

  Future<void> _refresBookingsList() async {
    controller.fetchAllBooking();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () => Provider.of<CurrentPage>(context, listen: false)
          .checkCurrentPageIndex(context),
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryThemeColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.plainWhite,
        ),
        child: GetBuilder<AdminBookingsController>(
          init: AdminBookingsController(),
          builder: (_) {
            return RefreshIndicator(
              color: AppColors.primaryThemeColor,
              backgroundColor: AppColors.scaffoldBackgroundColor(context),
              onRefresh: _refresBookingsList,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 3,
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.lightGray,
                  backgroundColor: AppColors.primaryThemeColor,
                  title: Text(
                    AppStrings.bookings,
                    style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
                  ),
                ),
                body: controller.showLoading == true
                    ? loadingWidget()
                    : Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        child: controller.bookingsList?.isEmpty == true
                            ? const Center(child: Text("No bookings found"))
                            : ListView.builder(
                                itemCount: controller.bookingsList?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final booking =
                                      controller.bookingsList?[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: adminBookingCard(context, booking),
                                  );
                                },
                              ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
