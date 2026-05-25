import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_auth/agent_auth_model/agent_model.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_model/agent_job_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AgentFirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _agents = 'Agents';
  static const String _agentJobs = 'AgentJobs';

  // ─── AUTH ────────────────────────────────────────────────────────────────


  Future<bool> registerAgent(AgentModel agent) async {
    try {
      await _db.collection(_agents).doc(agent.agentId).set(agent.toJson());
      Fluttertoast.showToast(
        msg: 'Application submitted successfully!',
        backgroundColor: AppColors.normalGreen,
      );
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error registering. Retry.');
      return false;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final result = await _db
          .collection(_agents)
          .where('email', isEqualTo: email)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ─── ADMIN: approve/reject agent ─────────────────────────────────────────

  Future<bool> approveAgent(String agentId, bool approved) async {
    try {
      await _db.collection(_agents).doc(agentId).update({'isApproved': approved});
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<List<AgentModel>> fetchPendingAgents() async {
    try {
      final result = await _db
          .collection(_agents)
          .where('isApproved', isEqualTo: false)
          .get();
      return result.docs
          .map((doc) => AgentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<AgentModel?> signInAgent(String email, String password) async {
    try {
      final result = await _db
          .collection(_agents)
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (result.docs.isEmpty) {
        Fluttertoast.showToast(msg: 'Incorrect email or password');
        return null;
      }
      return AgentModel.fromJson(result.docs[0].data());
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error signing in. Retry.');
      return null;
    }
  }

  Future<AgentModel?> getAgentById(String agentId) async {
    try {
      final doc = await _db.collection(_agents).doc(agentId).get();
      if (!doc.exists) return null;
      return AgentModel.fromJson(doc.data()!);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  // ─── STATUS ──────────────────────────────────────────────────────────────

  Future<bool> updateAgentStatus(String agentId, String status) async {
    try {
      await _db.collection(_agents).doc(agentId).update({'status': status});
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error updating status');
      return false;
    }
  }

  // ─── JOBS ────────────────────────────────────────────────────────────────

  Stream<List<AgentJobModel>> listenToAgentJobs(String agentId) {
    return _db
        .collection(_agentJobs)
        .where('agentId', isEqualTo: agentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AgentJobModel.fromJson(doc.data()))
            .toList()
          ..sort((a, b) =>
              (b.assignedAt ?? DateTime.now())
                  .compareTo(a.assignedAt ?? DateTime.now())));
  }

  Future<List<AgentJobModel>> fetchAgentJobs(String agentId) async {
    try {
      final result = await _db
          .collection(_agentJobs)
          .where('agentId', isEqualTo: agentId)
          .get();
      final jobs = result.docs
          .map((doc) => AgentJobModel.fromJson(doc.data()))
          .toList();
      jobs.sort((a, b) => (b.assignedAt ?? DateTime.now())
          .compareTo(a.assignedAt ?? DateTime.now()));
      return jobs;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<bool> updateAgentJob(AgentJobModel job) async {
    try {
      await _db
          .collection(_agentJobs)
          .doc(job.jobId)
          .set(job.toJson());
      return true;
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: 'Error updating job. Retry.',
        backgroundColor: AppColors.coolRed,
      );
      return false;
    }
  }

  Future<bool> uploadJobPhotos({
    required String jobId,
    required List<String> photoUrls,
    required bool isBefore,
  }) async {
    try {
      await _db.collection(_agentJobs).doc(jobId).update({
        isBefore ? 'beforePhotoUrls' : 'afterPhotoUrls': photoUrls,
      });
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  // ─── ADMIN: fetch all agents (for dashboard) ─────────────────────────────

  Future<List<AgentModel>> fetchAllAgents() async {
    try {
      final result = await _db.collection(_agents).get();
      return result.docs
          .map((doc) => AgentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Stream<List<AgentModel>> listenToAllAgents() {
    return _db.collection(_agents).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AgentModel.fromJson(doc.data())).toList());
  }
}
