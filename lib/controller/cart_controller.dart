import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cart/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  final String userId = "demo_user"; // Replace with actual logged-in user ID
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadCartFromFirestore();
  }

  void loadCartFromFirestore() async {
    final doc = await firestore.collection("cart").doc(userId).get();
    if (doc.exists && doc.data() != null && doc.data()!['items'] != null) {
      final List items = doc.data()!['items'];
      cartItems.value = items.map((e) => CartItem.fromMap(e)).toList();
    }
  }

  void saveCartToFirestore() {
    final List items = cartItems.map((e) => e.toMap()).toList();
    firestore.collection("cart").doc(userId).set({'items': items});
  }

  void addToCart(CartItem item) {
    final index = cartItems.indexWhere((i) => i.productId == item.productId);
    if (index != -1) {
      cartItems[index].quantity += 1;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
    saveCartToFirestore();
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((i) => i.productId == productId);
    saveCartToFirestore();
  }

  void updateQuantity(String productId, int newQty) {
    if (newQty <= 0) {
      removeFromCart(productId);
    } else {
      final index = cartItems.indexWhere((i) => i.productId == productId);
      if (index != -1) {
        cartItems[index].quantity = newQty;
        cartItems.refresh();
        saveCartToFirestore();
      }
    }
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
