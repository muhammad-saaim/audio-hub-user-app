import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/product/product.dart';
import '../controller/order_controller.dart';

class ProductDescriptionPage extends StatefulWidget {
  const ProductDescriptionPage({super.key});

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  final TextEditingController addressCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    Product product = arguments['data'];

    final orderCtrl = Get.put(OrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image ?? '',
                fit: BoxFit.contain,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),

            // Product name
            Text(
              product.name ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Product description
            Text(
              product.description ?? '',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Product price
            Text(
              'Rs : ${product.price ?? ''}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Billing address input
            TextField(
              controller: addressCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Enter your Billing Address',
              ),
            ),
            const SizedBox(height: 20),

            // Buy Now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'Buy now',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () async {
                  if (addressCtrl.text.trim().isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter billing address",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  // Create order for the current logged-in user
                  await orderCtrl.createOrder(
                    address: addressCtrl.text.trim(),
                    item: product.name ?? '',
                    price: "${product.price ?? ''}",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
