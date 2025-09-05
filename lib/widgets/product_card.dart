import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../model/cart/cart_item.dart';

class ProductCard extends StatelessWidget {
  final String productId; // Unique ID (Firestore ID ya koi bhi)
  final String name;
  final String imageUrl;
  final double price;
  final String offerTag;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;

  const ProductCard({
    super.key,
    this.productId = "", // default diya taaki error na aaye
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.offerTag,
    required this.onTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Text + Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),

                  // Price
                  Text(
                    'Rs : $price',
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),

                  // Offer + Wishlist + Cart Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Offer Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          offerTag,
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),

                      // Wishlist + Add to Cart
                      Row(
                        children: [
                          if (onWishlistTap != null)
                            InkWell(
                              onTap: onWishlistTap,
                              child: const Icon(Icons.favorite_border,
                                  color: Colors.red, size: 18),
                            ),

                          const SizedBox(width: 6),

                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart,
                                color: Colors.blue, size: 20),
                            onPressed: () {
                              final item = CartItem(
                                productId: productId.isNotEmpty ? productId : name,
                                name: name,
                                price: price,
                                image: imageUrl,
                              );

                              cartController.addToCart(item);

                              Get.snackbar(
                                "Added to Cart",
                                "$name added successfully!",
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
