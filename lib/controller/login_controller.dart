import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../pages/verify_email_page.dart';
import '../pages/main_screen.dart';

class LoginController extends GetxController {
  fbAuth.FirebaseAuth auth = fbAuth.FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Controllers for registration
  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerEmailCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();
  TextEditingController registerPasswordCtrl = TextEditingController();

  bool agree = false;

  // Rx variables for profile
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  // Load current user from Firestore
  Future<void> loadCurrentUser() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        final doc = await firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          userName.value = doc['name'] ?? '';
          userEmail.value = doc['email'] ?? '';
          userPhone.value = doc['number'] ?? '';
          userAddress.value = doc['address'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
    }
  }

  // Update profile in Firestore
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        await firestore.collection('users').doc(uid).update({
          'name': name,
          'email': email,
          'number': phone,
        });
        userName.value = name;
        userEmail.value = email;
        userPhone.value = phone;

        Get.snackbar("Success", "Profile updated successfully ✅");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Update address
  Future<void> updateAddress(String newAddress) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        await firestore.collection('users').doc(uid).update({
          'address': newAddress,
        });
        userAddress.value = newAddress;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      await auth.signOut(); // Firebase logout
      userName.value = '';
      userEmail.value = '';
      userPhone.value = '';
      userAddress.value = '';
      Get.offAllNamed('/login'); // Redirect to login page
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Register user
  Future<bool> addUser() async {
    if (!agree) {
      Get.snackbar("Error", "Please agree to terms and conditions");
      return false;
    }

    try {
      fbAuth.UserCredential userCred =
      await auth.createUserWithEmailAndPassword(
        email: registerEmailCtrl.text.trim(),
        password: registerPasswordCtrl.text,
      );

      await firestore.collection('users').doc(userCred.user!.uid).set({
        'name': registerNameCtrl.text.trim(),
        'email': registerEmailCtrl.text.trim(),
        'number': registerNumberCtrl.text.trim(),
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await userCred.user?.sendEmailVerification();

      Get.to(() => VerifyEmailPage(email: registerEmailCtrl.text.trim()));
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  // Login user
  Future<void> loginUser(String email, String password) async {
    try {
      final userCred = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCred.user != null) {
        if (userCred.user!.emailVerified) {
          await loadCurrentUser();
          Get.offAll(() => MainScreen());
        } else {
          Get.snackbar("Verify Email", "Please verify your email first");
          await userCred.user!.sendEmailVerification();
        }
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }
}
