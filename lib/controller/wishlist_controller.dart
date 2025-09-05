import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> wishlistItems = <Map<String, dynamic>>[].obs;

  String userId = ''; // Logged-in user ka UID set karenge

  // Fetch wishlist for current user
  Future<void> fetchWishlist(String uid) async {
    try {
      userId = uid;
      DocumentSnapshot doc = await firestore.collection('wishlist').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;

        // Ensure items is always a List
        final rawItems = data['items'];
        List<dynamic> items = [];

        if (rawItems is List) {
          items = rawItems;
        } else if (rawItems is Map) {
          items = [rawItems]; // wrap single map into list
        }

        wishlistItems.assignAll(items.map((e) => Map<String, dynamic>.from(e)).toList());
      } else {
        wishlistItems.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Add product to wishlist
  Future<void> addToWishlist(Map<String, dynamic> product) async {
    try {
      DocumentReference docRef = firestore.collection('wishlist').doc(userId);
      DocumentSnapshot doc = await docRef.get();

      List<dynamic> items = [];
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final rawItems = data['items'];

        if (rawItems is List) {
          items = rawItems;
        } else if (rawItems is Map) {
          items = [rawItems];
        }
      }

      // Check if product already exists
      if (!items.any((item) => item['productId'] == product['productId'])) {
        items.add(product);
        await docRef.set({'userId': userId, 'items': items});
        wishlistItems.assignAll(items.map((e) => Map<String, dynamic>.from(e)).toList());
        Get.snackbar('Success', 'Added to wishlist');
      } else {
        Get.snackbar('Info', 'Product already in wishlist');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      DocumentReference docRef = firestore.collection('wishlist').doc(userId);
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;

        final rawItems = data['items'];
        List<dynamic> items = [];

        if (rawItems is List) {
          items = rawItems;
        } else if (rawItems is Map) {
          items = [rawItems];
        }

        items.removeWhere((item) => item['productId'] == productId);
        await docRef.set({'userId': userId, 'items': items});
        wishlistItems.assignAll(items.map((e) => Map<String, dynamic>.from(e)).toList());
        Get.snackbar('Removed', 'Product removed from wishlist');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
