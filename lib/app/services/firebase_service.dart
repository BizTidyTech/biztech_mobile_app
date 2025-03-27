import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_auth/admin_auth_model/admin_data_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/fb_collection_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> register({required UserData user}) async {
    try {
      final QuerySnapshot result = await firebaseFirestore
          .collection(FbCollectionNames.user)
          .where("email", isEqualTo: user.email)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        final userDataJson = user.toJson();
        logger.f("userDataJson: $userDataJson");
        firebaseFirestore
            .collection(FbCollectionNames.user)
            .doc(user.userId)
            .set(userDataJson);
        await saveUserDetailsLocally(user);
        Fluttertoast.showToast(msg: "Account created successfully!");
        return true;
      } else {
        Fluttertoast.showToast(
            msg: 'User with email ${user.email} already exists.');
        return false;
      }
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error occured! Retry.');
      return false;
    }
  }

  Future<UserData?> getUserDetails({required String email}) async {
    try {
      final QuerySnapshot result = await firebaseFirestore
          .collection(FbCollectionNames.user)
          .where("email", isEqualTo: email)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      logger.w("documents: ${documents.length}");
      if (documents.isEmpty) {
        Fluttertoast.showToast(msg: 'User with email $email does not exist.');
        return null;
      } else {
        final userData =
            UserData.fromJson(result.docs[0].data() as Map<String, dynamic>);
        return userData;
      }
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error getting your data.');
      return null;
    }
  }

  Future<bool> updateUserProfile(UserData userData) async {
    try {
      await firebaseFirestore
          .collection(FbCollectionNames.user)
          .doc(userData.userId)
          .set(userData.toJson());
      Fluttertoast.showToast(
        msg: "Profile updated successfully!",
        backgroundColor: AppColors.normalGreen,
      );
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: 'Error updating your profile! Retry',
        backgroundColor: AppColors.coolRed,
      );
      return false;
    }
  }

  Future<bool> deleteUserProfile(UserData? userData) async {
    try {
      await firebaseFirestore
          .collection(FbCollectionNames.user)
          .doc(userData?.userId)
          .delete();
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: 'Error deleting your account! Retry',
        backgroundColor: AppColors.coolRed,
      );
      return false;
    }
  }

  Future<bool> bookAppointment({required BookingModel booking}) async {
    try {
      firebaseFirestore
          .collection(FbCollectionNames.bookings)
          .doc(booking.bookingId)
          .set(booking.toJson());
      Fluttertoast.showToast(msg: "Booked successfully!");
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error booking appointmnet! Retry.');
      return false;
    }
  }

  Future<bool> updateBooking(BookingModel booking) async {
    try {
      firebaseFirestore
          .collection(FbCollectionNames.bookings)
          .doc(booking.bookingId)
          .set(booking.toJson());
      Fluttertoast.showToast(msg: "Booking updated successfully!");
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
          msg: 'Error updating your booking! Kindly contact us');
      return false;
    }
  }

  Future<List<BookingModel>?> fetchMyBookings() async {
    try {
      final userId = (await getLocallySavedUserDetails())?.userId;
      logger.i("Fetching my bookings list with id $userId . . .");

      final QuerySnapshot result = await firebaseFirestore
          .collection(FbCollectionNames.bookings)
          .where("userId", isEqualTo: userId)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        Fluttertoast.showToast(msg: 'No bookings found');
      } else {
        final List<DocumentSnapshot> documents = result.docs;
        List<BookingModel> listOfBookings = List.generate(
          documents.length,
          (index) => BookingModel.fromJson(
              documents.elementAt(index).data() as Map<String, dynamic>),
        );
        return listOfBookings;
      }
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error getting my bookings');
    }
    return <BookingModel>[];
  }

  Future<List<BookingModel>?> adminFetchAllBookings() async {
    try {
      final QuerySnapshot result =
          await firebaseFirestore.collection(FbCollectionNames.bookings).get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        Fluttertoast.showToast(msg: 'No bookings found');
      } else {
        final List<DocumentSnapshot> documents = result.docs;
        List<BookingModel> listOfBookings = List.generate(
          documents.length,
          (index) => BookingModel.fromJson(
              documents.elementAt(index).data() as Map<String, dynamic>),
        );
        return listOfBookings;
      }
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error getting all bookings');
    }
    return <BookingModel>[];
  }

  Future<String?> fetchNotificationApiKey() async {
    try {
      DocumentSnapshot document =
          await firebaseFirestore.collection('Keys').doc('keysData').get();

      final notificationApiKey = document['notificationApiKey'];
      logger.f("notificationApiKey: $notificationApiKey");
      return notificationApiKey;
    } catch (e) {
      return null;
    }
  }

  Future<AdminAuthModel?> getAdminAuthDetails() async {
    try {
      DocumentSnapshot document = await firebaseFirestore
          .collection(FbCollectionNames.admin)
          .doc('auth')
          .get();
      final adminAuthDetails =
          AdminAuthModel.fromJson(document.data() as Map<String, dynamic>);
      return adminAuthDetails;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error occured! Retry.');
      return null;
    }
  }
}
