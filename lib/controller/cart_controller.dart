import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/cart/cart_item.dart';

class CartController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxList<CartItem> cartItems = <CartItem>[].obs;

  String get userId => auth.currentUser?.uid ?? "";

  @override
  void onInit() {
    super.onInit();
    if (userId.isNotEmpty) loadCart();
  }

  Future<void> loadCart() async {
    if (userId.isEmpty) return;
    final doc = await firestore.collection('users').doc(userId).collection('cart').doc('cart').get();
    if (doc.exists && doc.data() != null && doc.data()!['items'] != null) {
      final List items = doc.data()!['items'];
      cartItems.value = items.map((e) => CartItem.fromMap(e)).toList();
    } else {
      cartItems.clear();
    }
  }

  Future<void> saveCart() async {
    if (userId.isEmpty) return;
    final items = cartItems.map((e) => e.toMap()).toList();
    await firestore.collection('users').doc(userId).collection('cart').doc('cart').set({'items': items});
  }

  void addToCart(CartItem item) {
    final index = cartItems.indexWhere((i) => i.productId == item.productId);
    if (index != -1) {
      cartItems[index].quantity += item.quantity;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
    saveCart();
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((i) => i.productId == productId);
    saveCart();
  }

  void updateQuantity(String productId, int newQty) {
    final index = cartItems.indexWhere((i) => i.productId == productId);
    if (index != -1) {
      if (newQty <= 0) {
        removeFromCart(productId);
      } else {
        cartItems[index].quantity = newQty;
        cartItems.refresh();
        saveCart();
      }
    }
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void clearCart() {
    cartItems.clear();
  }
}
