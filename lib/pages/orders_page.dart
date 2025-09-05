import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  final OrderController orderCtrl = Get.put(OrderController()); // ✅ singular

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
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.deepPurple),
                title: Text(order['item'] ?? "No item"),
                subtitle: Text(
                    "Price: Rs ${order['price'] ?? '0'}\nDate: ${order['date time'] ?? ''}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Future: navigate to Order Details Page
                },
              ),
            );
          },
        );
      }),
    );
  }
}
