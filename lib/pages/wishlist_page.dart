import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/wishlist_controller.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});

  final WishlistController ctrl = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    // Replace this with your logged-in user UID
    String currentUserId = 'Bo26SGhw16gx5OtTcJg5';
    ctrl.fetchWishlist(currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.wishlistItems.isEmpty) {
          return const Center(child: Text('No items in wishlist'));
        }

        return ListView.builder(
          itemCount: ctrl.wishlistItems.length,
          itemBuilder: (context, index) {
            final item = ctrl.wishlistItems[index];
            return ListTile(
              leading: Image.network(
                item['image'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item['name'] ?? ''),
              subtitle: Text('Rs ${item['price']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ctrl.removeFromWishlist(item['productId']);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
