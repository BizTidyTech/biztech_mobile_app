// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/booking/booking_model/booking_model.dart';

class BookingsListController extends GetxController {
  BookingsListController();
  BookingModel? bookingData;
  List<BookingModel>? bookingsList = [];
  String errMessage = '';
  bool showLoading = false;

  clearVals() {
    showLoading = false;
    errMessage = '';
    bookingData = null;
    bookingsList = [];
    update();
  }

  changeSelectedBooking(BookingModel? booking) {
    logger.i("Selected ${booking?.service?.name}");
    bookingData = booking;
    update();
  }

  makePayment() {
    logger.w("Paying ${bookingData?.service?.name} . . . ");
  }

  updateBookingPayment() {}
}
