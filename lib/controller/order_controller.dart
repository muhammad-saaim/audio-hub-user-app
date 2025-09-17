import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class OrderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxList<Map<String, dynamic>> userOrders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  String get userId => auth.currentUser?.uid ?? "";

  @override
  void onInit() {
    super.onInit();
    if (userId.isNotEmpty) fetchUserOrders();
  }

  /// Create a new order
  Future<void> createOrder({
    required String item,
    required String price,
    required String address,
    String? itemId,
    String? image,
  }) async {
    if (userId.isEmpty) return;

    try {
      String orderId = firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc()
          .id;

      final orderData = {
        "item": item,
        "price": price,
        "address": address,
        "transactionId": orderId,
        "dateTime": DateFormat("dd-MM-yyyy").format(DateTime.now()),
        "status": "Pending",
        "itemId": itemId ?? item,
        "image": image ?? '',
      };

      await firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      userOrders.insert(0, orderData);
      Get.snackbar("Success", "Order placed successfully ✅");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Fetch all orders
  Future<void> fetchUserOrders() async {
    if (userId.isEmpty) return;

    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('dateTime', descending: true)
          .get();

      userOrders.value =
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel a single order
  Future<void> cancelOrder(String transactionId) async {
    if (userId.isEmpty) return;

    try {
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(transactionId);

      await docRef.update({'status': 'Cancelled'});

      final index = userOrders.indexWhere((o) => o['transactionId'] == transactionId);
      if (index != -1) {
        userOrders[index]['status'] = 'Cancelled';
        userOrders.refresh();
      }

      Get.snackbar(
        "Cancelled",
        "Order has been cancelled",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to cancel order: $e");
    }
  }

  /// Clear all orders
  Future<void> clearOrders() async {
    if (userId.isEmpty) return;

    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      userOrders.clear();
      Get.snackbar(
        "Orders Cleared",
        "All orders have been cleared",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to clear orders: $e", colorText: Colors.red);
    }
  }
}
