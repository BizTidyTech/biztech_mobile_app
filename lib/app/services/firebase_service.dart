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
      // final QuerySnapshot result = await firebaseFirestore
      //     .collection(FbCollectionNames.user)
      //     .where("email", isEqualTo: user.email)
      //     .get();

      // final List<DocumentSnapshot> documents = result.docs;
      // if (documents.isEmpty) {
      final userDataJson = user.toJson();
      logger.f("userDataJson: $userDataJson");
      firebaseFirestore
          .collection(FbCollectionNames.user)
          .doc(user.userId)
          .set(userDataJson);
      await saveUserDetailsLocally(user);
      Fluttertoast.showToast(msg: "Account created successfully!");
      return true;
      // } else {
      //   Fluttertoast.showToast(
      //       msg: 'User with email ${user.email} already exists.');
      //   return false;
      // }
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
      await firebaseFirestore
          .collection(FbCollectionNames.bookings)
          .doc(booking.bookingId)
          .set(booking.toJson());

      // ── Dispatch job to agents ──────────────────────────────────────────
      await _dispatchJobToAgents(booking);

      Fluttertoast.showToast(msg: "Booked successfully!");
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error booking appointmnet! Retry.');
      return false;
    }
  }

  Future<void> _dispatchJobToAgents(BookingModel booking) async {
    try {
      // Create AgentJob document in AgentJobs collection
      final jobId = 'job_${booking.bookingId}';
      final jobData = {
        'jobId': jobId,
        'bookingId': booking.bookingId,
        'agentId': null,
        'status': 'pending',
        'booking': booking.toJson(),
        'assignedAt': null,
        'startedAt': null,
        'completedAt': null,
        'beforePhotoUrls': [],
        'afterPhotoUrls': [],
        'rating': null,
        'clientReview': null,
        'agentEarnings': null,
        'broadcastedAt': DateTime.now().toIso8601String(),
        'rebroadcastCount': 0,
      };

      await firebaseFirestore
          .collection('AgentJobs')
          .doc(jobId)
          .set(jobData);

      logger.i('AgentJob created: $jobId');

      // Notify all online agents via their Firestore notification subcollection
      await _notifyOnlineAgents(booking, jobId);

    } catch (e) {
      logger.e('Error dispatching job: $e');
    }
  }

  Future<void> _notifyOnlineAgents(BookingModel booking, String jobId) async {
    try {
      // Fetch all online/approved agents
      final agentsSnap = await firebaseFirestore
          .collection('Agents')
          .where('isApproved', isEqualTo: true)
          .where('isSuspended', isEqualTo: false)
          .where('status', whereIn: ['online', 'on_job'])
          .get();

      if (agentsSnap.docs.isEmpty) {
        logger.w('No online agents available for dispatch');
        return;
      }

      logger.i('Dispatching to ${agentsSnap.docs.length} online agents');

      // Write notification to each agent's Notifications subcollection
      for (final agentDoc in agentsSnap.docs) {
        final agentId = agentDoc.id;
        final notifId = 'notif_job_$jobId';
        await firebaseFirestore
            .collection('Agents')
            .doc(agentId)
            .collection('Notifications')
            .doc(notifId)
            .set({
          'id': notifId,
          'title': 'New Job Available!',
          'body':
          '${booking.service?.name ?? 'Cleaning'} job in ${booking.locationName ?? 'your area'}. Tap to accept.',
          'type': 'job',
          'jobId': jobId,
          'createdAt': Timestamp.now(),
          'isRead': false,
        });
      }
    } catch (e) {
      logger.e('Error notifying agents: $e');
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

  Future<String?> fetchPaystackApiKey() async {
    try {
      DocumentSnapshot document =
      await firebaseFirestore.collection('Keys').doc('keysData').get();

      final paystackSecretKey = document['paystackSecretKey'];
      logger.f("paystackSecretKey: $paystackSecretKey");
      return paystackSecretKey;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>?> fetchPayPalSecretKeyAndClientID() async {
    try {
      DocumentSnapshot document =
      await firebaseFirestore.collection('Keys').doc('keysData').get();

      final paypalSecretKey = document['paypalSecretKey'];
      final paypalClientId = document['paypalClientId'];
      logger.f(
          "paypalSecretKey: $paypalSecretKey \npaypalClientId: $paypalClientId");
      return [paypalSecretKey, paypalClientId];
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

  // ── Job photos (real-time stream for client) ──────────────────────────────

  /// Streams the AgentJob document for a given bookingId in real time.
  /// The client booking details screen subscribes to this so photos appear
  /// the moment the agent uploads them — no manual refresh needed.
  Stream<Map<String, dynamic>?> streamAgentJob(String bookingId) {
    final jobId = 'job_$bookingId';
    return firebaseFirestore
        .collection('AgentJobs')
        .doc(jobId)
        .snapshots()
        .map((snap) => snap.exists ? snap.data() : null);
  }

  // ── Rating ─────────────────────────────────────────────────────────────────

  /// Fetches the AgentJob document for a given bookingId.
  /// Returns null if no job exists yet (agent not yet assigned).
  Future<Map<String, dynamic>?> fetchAgentJob(String bookingId) async {
    try {
      final jobId = 'job_$bookingId';
      final doc = await firebaseFirestore
          .collection('AgentJobs')
          .doc(jobId)
          .get();
      if (!doc.exists || doc.data() == null) return null;
      return doc.data();
    } catch (e) {
      logger.e('fetchAgentJob error: $e');
      return null;
    }
  }

  /// Submits a client rating. Uses a Firestore transaction on the Agents doc
  /// so the rolling average and pendingPayout are updated atomically.
  ///
  /// Agent earnings formula (matches SOP §4):
  ///   Agent share : baseCost × 0.60  (60/40 split, no deductions)
  Future<bool> submitJobRating({
    required String bookingId,
    required String agentId,
    required double rating,
    required String review,
    required double jobCost,
    required bool isUSD,
  }) async {
    try {
      final jobId = 'job_$bookingId';
      final rawEarnings = jobCost * 0.60;
      final agentEarnings = rawEarnings;
      final cleanReview = review.trim().isEmpty ? null : review.trim();
      final now = DateTime.now();

      // 1 ── Bookings doc
      await firebaseFirestore
          .collection(FbCollectionNames.bookings)
          .doc(bookingId)
          .update({
        'clientRating': rating,
        'clientReview': cleanReview,
        'ratedAt': now.toIso8601String(),
      });

      // 2 ── AgentJobs doc (admin Quality + agent Earnings screens read these)
      await firebaseFirestore
          .collection('AgentJobs')
          .doc(jobId)
          .update({
        'rating': rating,
        'clientReview': cleanReview,
        'agentEarnings': agentEarnings,
      });

      // 3 ── Agents doc — atomic transaction for safe rolling-average math
      await firebaseFirestore.runTransaction((tx) async {
        final agentRef =
        firebaseFirestore.collection('Agents').doc(agentId);
        final snap = await tx.get(agentRef);
        if (!snap.exists) return;

        final data = snap.data()!;
        final prevRating =
            (data['rating'] as num?)?.toDouble() ?? 5.0;
        final prevJobs =
            (data['totalJobsCompleted'] as num?)?.toInt() ?? 0;
        final prevEarnings =
            (data['totalEarnings'] as num?)?.toDouble() ?? 0.0;
        final prevPending =
            (data['pendingPayout'] as num?)?.toDouble() ?? 0.0;

        // Weighted rolling average
        final newRating = prevJobs == 0
            ? rating
            : ((prevRating * prevJobs) + rating) / (prevJobs + 1);

        tx.update(agentRef, {
          'rating': double.parse(newRating.toStringAsFixed(1)),
          'totalJobsCompleted': prevJobs + 1,
          'totalEarnings': prevEarnings + agentEarnings,
          'pendingPayout': prevPending + agentEarnings,
        });
      });

      // 4 ── Notify agent via Notifications subcollection
      final notifId = 'rating_$bookingId';
      final starWord = rating == 5.0
          ? 'Amazing work'
          : rating >= 4.0
          ? 'Great job'
          : rating >= 3.0
          ? 'Good effort'
          : 'Room to improve';
      final truncated = cleanReview != null && cleanReview.length > 60
          ? '${cleanReview.substring(0, 60)}…'
          : cleanReview;
      final notifBody = cleanReview != null
          ? '$starWord — "$truncated"'
          : '$starWord — a client rated your recent job ${rating.toInt()}/5 stars.';

      await firebaseFirestore
          .collection('Agents')
          .doc(agentId)
          .collection('Notifications')
          .doc(notifId)
          .set({
        'id': notifId,
        'title': '${rating.toInt()}-star rating received!',
        'body': notifBody,
        'type': 'rating',
        'jobId': jobId,
        'createdAt': Timestamp.now(),
        'isRead': false,
      });

      return true;
    } catch (e) {
      logger.e('submitJobRating error: $e');
      return false;
    }
  }
}