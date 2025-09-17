import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxList<Map<String, dynamic>> userOrders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; // reactive loading state

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
      };

      await firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      // Add locally to reactive list
      userOrders.insert(0, orderData);

      Get.snackbar("Success", "Order placed successfully ✅");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Fetch all orders of the current user
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

  /// Clear orders locally and optionally in Firestore (used on logout)
  Future<void> clearOrders({bool deleteFromFirestore = false}) async {
    if (deleteFromFirestore && userId.isNotEmpty) {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to clear orders from Firestore: $e");
      }
    }
    userOrders.clear();
  }
}
