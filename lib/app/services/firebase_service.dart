import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';
import 'package:tidytech/utils/app_constants/fb_collection_names.dart';

class FirebaseService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> register({required UserData user}) async {
    try {
      final QuerySnapshot result = await firebaseFirestore
          .collection(FbCollectionNames.user)
          .where("userId", isEqualTo: user.userId)
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
}
