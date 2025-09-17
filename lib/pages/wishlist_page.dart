import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/wishlist_controller.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});

  final WishlistController ctrl = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch wishlist for the logged-in user
      ctrl.fetchWishlist();
    } else {
      // User not logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'No user logged in');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (ctrl.wishlistItems.isEmpty) {
          return const Center(
            child: Text('No items in wishlist'),
          );
        }

        return ListView.builder(
          itemCount: ctrl.wishlistItems.length,
          itemBuilder: (context, index) {
            final item = ctrl.wishlistItems[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
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
                  onPressed: () async {
                    await ctrl.removeFromWishlist(item['productId']);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
