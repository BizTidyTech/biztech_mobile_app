// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/agent_sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/agent_firebase_service.dart';

import 'package:biztidy_mobile_app/ui/features_agent/agent_auth/agent_auth_model/agent_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AgentAuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPhoneController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();
  TextEditingController signupAddressController = TextEditingController();

  bool showLoading = false;
  bool isObscured = true;
  bool isSignupObscured = true;
  String errMessage = '';

  void toggleObscure() { isObscured = !isObscured; update(); }
  void toggleSignupObscure() { isSignupObscured = !isSignupObscured; update(); }
  void startLoading() { showLoading = true; errMessage = ''; update(); }
  void stopLoading() { showLoading = false; update(); }
  void resetValues() {
    errMessage = ''; showLoading = false;
    emailController.clear(); passwordController.clear(); update();
  }

  Future<void> attemptSignIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      errMessage = 'Email and password are required'; update(); return;
    }
    startLoading();
    final agent = await AgentFirebaseService().signInAgent(email, password);
    if (agent != null) {
      if (agent.isApproved != true) {
        await saveAgentDetailsLocally(agent);
        stopLoading();
        context.go('/agentPendingApprovalScreen');
        return;
      }
      await saveAgentDetailsLocally(agent);
      Fluttertoast.showToast(msg: 'Welcome back, ${agent.name ?? "Agent"}!', backgroundColor: AppColors.normalGreen);
      context.go('/agentHomeScreen');
    } else {
      errMessage = 'Incorrect email or password'; update();
    }
    stopLoading();
  }

  Future<void> attemptSignUp(BuildContext context) async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final phone = signupPhoneController.text.trim();
    final password = signupPasswordController.text.trim();
    final confirm = signupConfirmPasswordController.text.trim();
    final address = signupAddressController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirm.isEmpty) {
      errMessage = 'All fields are required'; update(); return;
    }
    if (password != confirm) { errMessage = 'Passwords do not match'; update(); return; }
    if (password.length < 6) { errMessage = 'Password must be at least 6 characters'; update(); return; }

    startLoading();
    final emailExists = await AgentFirebaseService().checkEmailExists(email);
    if (emailExists) { errMessage = 'An agent with this email already exists'; stopLoading(); return; }

    final agentId = FirebaseFirestore.instance.collection('Agents').doc().id;
    final newAgent = AgentModel(
      agentId: agentId, name: name, email: email, password: password,
      phoneNumber: phone, address: address, status: 'offline',
      rating: 5.0, totalJobsCompleted: 0, totalEarnings: 0.0,
      isApproved: false, timeCreated: DateTime.now(),
    );

    final success = await AgentFirebaseService().registerAgent(newAgent);
    if (success) {
      await saveAgentDetailsLocally(newAgent);
      context.go('/agentPendingApprovalScreen');
    } else {
      errMessage = 'Registration failed. Please try again.'; update();
    }
    stopLoading();
  }

  Future<void> signOut(BuildContext context) async {
    final agent = await getLocallySavedAgentDetails();
    if (agent?.agentId != null) {
      await AgentFirebaseService().updateAgentStatus(agent!.agentId!, 'offline');
    }
    await clearAgentDetailsLocally();
    context.go('/');
  }
}
