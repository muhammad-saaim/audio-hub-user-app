import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../model/cart/cart_item.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartController cartController = Get.find<CartController>();

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
                        width: 150, // Enough width for all buttons
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Remove button
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () => cartController.updateQuantity(
                                  item.productId, item.quantity - 1),
                            ),

                            // Quantity text (Flexible for responsive layout)
                            Flexible(
                              child: Text(
                                item.quantity.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Add button
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () => cartController.updateQuantity(
                                  item.productId, item.quantity + 1),
                            ),

                            // Delete button
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

            // Total + Checkout
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
                      Get.snackbar(
                        "Checkout",
                        "Checkout clicked!",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text("Checkout"),
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
