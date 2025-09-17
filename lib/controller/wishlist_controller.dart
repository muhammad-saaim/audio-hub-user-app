import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> wishlistItems = <Map<String, dynamic>>[].obs;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void onInit() {
    super.onInit();
    if (userId.isNotEmpty) fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    if (userId.isEmpty) return;
    try {
      final snapshot = await firestore.collection('users').doc(userId).collection('wishlist').get();
      wishlistItems.value =
          snapshot.docs.map((doc) => Map<String, dynamic>.from(doc.data())).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addToWishlist(Map<String, dynamic> product) async {
    if (userId.isEmpty) return;
    final docRef = firestore.collection('users').doc(userId).collection('wishlist').doc(product['productId']);
    if (!wishlistItems.any((p) => p['productId'] == product['productId'])) {
      await docRef.set(product);
      wishlistItems.add(product);
      Get.snackbar('Success', 'Added to wishlist');
    } else {
      Get.snackbar('Info', 'Product already in wishlist');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    if (userId.isEmpty) return;
    final docRef = firestore.collection('users').doc(userId).collection('wishlist').doc(productId);
    await docRef.delete();
    wishlistItems.removeWhere((item) => item['productId'] == productId);
    Get.snackbar('Removed', 'Product removed from wishlist');
  }

  void clearWishlist() {
    if (userId.isEmpty) return;
    firestore.collection('users').doc(userId).collection('wishlist').get().then((snap) {
      for (var doc in snap.docs) {
        doc.reference.delete();
      }
    });
    wishlistItems.clear();
  }
}
