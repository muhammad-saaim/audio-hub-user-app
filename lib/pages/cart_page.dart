import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/order_controller.dart';
import '../model/cart/cart_item.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.put(OrderController());
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text("Your cart is empty"));
        }

        return Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final CartItem item = cartController.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Image.network(
                        item.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.name),
                      subtitle: Text("Rs ${item.price}"),
                      trailing: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () => cartController.updateQuantity(
                                  item.productId, item.quantity - 1),
                            ),
                            Flexible(
                              child: Text(
                                item.quantity.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () => cartController.updateQuantity(
                                  item.productId, item.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  cartController.removeFromCart(item.productId),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Total + Buy Now
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    "Total: Rs ${cartController.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  ElevatedButton(
                    onPressed: () {
                      if (cartController.cartItems.isEmpty) {
                        Get.snackbar(
                          'Cart Empty',
                          'Add items to cart before checkout',
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: Colors.red,
                        );
                        return;
                      }

                      double total = cartController.totalPrice;

                      // Show dialog with editable address
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Confirm Order'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Total: Rs $total"),
                              const SizedBox(height: 10),
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Billing Address',
                                  hintText: 'Enter your address',
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (addressController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    'Address Required',
                                    'Please enter a billing address',
                                    snackPosition: SnackPosition.BOTTOM,
                                    colorText: Colors.red,
                                  );
                                  return;
                                }

                                // Create order for each cart item
                                for (var item in cartController.cartItems) {
                                  await orderController.createOrder(
                                    item: item.name,
                                    price: item.price.toString(),
                                    address: addressController.text.trim(),
                                  );
                                }

                                // Clear cart both locally and from Firestore
                                await cartController.clearCart();

                                Get.back(); // close dialog

                                Get.snackbar(
                                  'Order Placed',
                                  'Your order has been placed successfully!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  colorText: Colors.green,
                                );
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("Buy Now"),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
