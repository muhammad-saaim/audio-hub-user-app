import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../controller/cart_controller.dart';
import '../model/cart/cart_item.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  final OrderController orderCtrl = Get.put(OrderController());
  final CartController cartCtrl = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (orderCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderCtrl.userOrders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orderCtrl.userOrders.length,
          itemBuilder: (context, index) {
            final order = orderCtrl.userOrders[index];

            String status = order['status'] ?? "Pending";
            Color statusColor = (status == "Delivered")
                ? Colors.green
                : (status == "Cancelled")
                ? Colors.red
                : Colors.orange;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.deepPurple),
                title: Text(order['item'] ?? "No item"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price: Rs ${order['price'] ?? '0'}"),
                    Text("Date: ${order['dateTime'] ?? ''}"),
                    Text("Address: ${order['address'] ?? ''}"),
                    Text(
                      "Status: $status",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: Wrap(
                  spacing: 5,
                  children: [
                    if (status == "Pending")
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        tooltip: "Cancel Order",
                        onPressed: () =>
                            orderCtrl.cancelOrder(order['transactionId']),
                      ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.deepPurple),
                      tooltip: "Buy Again",
                      onPressed: () {
                        final newItem = CartItem(
                          productId: order['itemId'] ?? order['item'] ?? "unknown",
                          name: order['item'] ?? "Unknown",
                          price: double.tryParse(order['price'] ?? '0') ?? 0,
                          image: order['image'] ?? 'https://via.placeholder.com/150',
                          quantity: 1,
                        );
                        cartCtrl.addToCart(newItem);

                        Get.snackbar(
                          "Added to Cart",
                          "Item added back to cart",
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: Colors.green,
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Get.dialog(AlertDialog(
                    title: const Text("Order Details"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Item: ${order['item'] ?? 'Unknown'}"),
                        Text("Price: Rs ${order['price'] ?? '0'}"),
                        Text("Address: ${order['address'] ?? 'N/A'}"),
                        Text("Date: ${order['dateTime'] ?? 'N/A'}"),
                        Text("Status: $status"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Close"),
                      ),
                    ],
                  ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
