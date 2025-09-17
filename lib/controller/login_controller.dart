import 'package:audio_hub_client/pages/main_screen.dart' as main_page;
import 'package:audio_hub_client/pages/verify_email_page.dart' as verify_page;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';
import 'cart_controller.dart';
import 'wishlist_controller.dart';
import 'order_controller.dart';

class LoginController extends GetxController {
  final fbAuth.FirebaseAuth auth = fbAuth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Registration controllers
  final TextEditingController registerNameCtrl = TextEditingController();
  final TextEditingController registerEmailCtrl = TextEditingController();
  final TextEditingController registerNumberCtrl = TextEditingController();
  final TextEditingController registerPasswordCtrl = TextEditingController();

  // Login controllers
  final TextEditingController loginEmailCtrl = TextEditingController();
  final TextEditingController loginPasswordCtrl = TextEditingController();

  // Agreement & Remember Me
  var agree = false.obs;
  var rememberMe = false;

  // Rx variables for user profile
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userAddress = ''.obs;

  // Loading flag for Splash/Remember Me check
  var isCheckingRememberMe = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Initialize user on Splash
  Future<void> initializeUser() async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool('rememberMe') ?? false;

    final currentUser = auth.currentUser;
    if (currentUser != null && rememberMe) {
      await loadCurrentUser();

      // Initialize controllers with current user data
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().loadCart();
      }
      if (Get.isRegistered<OrderController>()) {
        await Get.find<OrderController>().fetchUserOrders();
      }
      if (Get.isRegistered<WishlistController>()) {
        await Get.find<WishlistController>().fetchWishlist();
      }

      Get.offAll(() => main_page.MainScreen());
    } else {
      Get.offAll(() => const LoginPage());
    }

    isCheckingRememberMe.value = false;
  }

  /// Toggle Remember Me from UI
  void toggleRememberMe(bool value) {
    rememberMe = value;
    update();
  }

  /// Load current user data from Firestore
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

  /// Logout user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', false);

      await auth.signOut();

      // Clear user-specific data
      if (Get.isRegistered<CartController>()) Get.find<CartController>().clearCart();
      if (Get.isRegistered<WishlistController>()) Get.find<WishlistController>().clearWishlist();
      if (Get.isRegistered<OrderController>()) Get.find<OrderController>().clearOrders();

      userName.value = '';
      userEmail.value = '';
      userPhone.value = '';
      userAddress.value = '';

      Get.offAll(() => const LoginPage());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Register user
  Future<bool> addUser() async {
    if (!agree.value) {
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

      Get.to(() => verify_page.VerifyEmailPage(
        email: registerEmailCtrl.text.trim(),
      ));
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  /// Login user
  Future<void> login(String email, String password) async {
    try {
      final userCred = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCred.user != null) {
        if (userCred.user!.emailVerified) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('rememberMe', rememberMe);

          await loadCurrentUser();

          // Initialize controllers with current user data
          if (Get.isRegistered<CartController>()) {
            await Get.find<CartController>().loadCart();
          }
          if (Get.isRegistered<OrderController>()) {
            await Get.find<OrderController>().fetchUserOrders();
          }
          if (Get.isRegistered<WishlistController>()) {
            await Get.find<WishlistController>().fetchWishlist();
          }

          Get.offAll(() => main_page.MainScreen());
        } else {
          Get.snackbar("Verify Email", "Please verify your email first");
          await userCred.user!.sendEmailVerification();
        }
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }

  /// Update user profile
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

        Get.snackbar("Success", "Profile updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }

  /// Update user address
  Future<void> updateAddress(String address) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        await firestore.collection('users').doc(uid).update({
          'address': address,
        });

        userAddress.value = address;

        Get.snackbar("Success", "Address updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update address: $e");
    }
  }
}
