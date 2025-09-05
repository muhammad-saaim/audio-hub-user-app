import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var userOrders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
  }

  // Create order
  Future<void> createOrder({
    required String customer,
    required String address,
    required String phone,
    required String item,
    required String price,
  }) async {
    try {
      String orderId = firestore.collection("orders").doc().id;

      await firestore.collection("orders").doc(orderId).set({
        "customer": customer,
        "address": address,
        "phone": phone,
        "item": item,
        "price": price,
        "transactionId": orderId, // dummy transaction
        "date time": DateFormat("dd-MM-yyyy").format(DateTime.now()),
      });

      Get.snackbar("Success", "Order placed successfully ✅");
      fetchUserOrders(); // Refresh orders list
      Get.offAllNamed("/home");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Fetch orders for current logged-in user
  Future<void> fetchUserOrders() async {
    try {
      final user = auth.currentUser;
      if (user == null) return; // no logged-in user

      isLoading.value = true;

      QuerySnapshot snapshot = await firestore
          .collection("orders")
          .where("customer", isEqualTo: user.displayName ?? "test customer")
          .get();

      userOrders.value =
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
