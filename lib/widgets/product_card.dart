import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../model/cart/cart_item.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final String offerTag;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;

  const ProductCard({
    super.key,
    this.productId = "",
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
    final RxBool isFav = false.obs;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Bottom Info Section
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name & Price
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rs : $price',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

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
                              Obx(() {
                                return InkWell(
                                  onTap: () {
                                    isFav.value = !isFav.value;
                                    onWishlistTap!();
                                  },
                                  child: Icon(
                                    isFav.value ? Icons.favorite : Icons.favorite_border,
                                    color: isFav.value ? Colors.red : Colors.grey,
                                    size: 26, // slightly smaller
                                  ),
                                );
                              }),
                            const SizedBox(width: 4),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
