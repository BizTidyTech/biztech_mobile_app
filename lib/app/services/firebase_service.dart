import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features/booking/booking_model/booking_model.dart';
import 'package:tidytech/utils/app_constants/fb_collection_names.dart';

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
        firebaseFirestore
            .collection(FbCollectionNames.user)
            .doc(user.userId)
            .set(user.toJson());
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
}
