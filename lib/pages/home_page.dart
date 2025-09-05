import 'package:audio_hub_client/controller/home_controller.dart';
import 'package:audio_hub_client/controller/wishlist_controller.dart';
import 'package:audio_hub_client/pages/product_description_page.dart';
import 'package:audio_hub_client/widgets/drop_down_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/multi_select_drop_down.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistCtrl = Get.put(WishlistController()); // Wishlist controller instance

    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Audiohub Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.productCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Chip(
                          label: Text(ctrl.productCategories[index].name ?? 'Error'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropDownBtn(
                      items: ['Rs : low to high', 'Rs : High to low'],
                      selectedItemText: 'Sort',
                      onSelected: (selected) {
                        ctrl.sortByPrice(
                            ascending: selected == 'Rs : low to high' ? true : false);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MultiSelectDropDown(
                      items: ['Apple', 'Audionic', 'Samsung', 'Gaming', 'Sony', 'Chinese'],
                      onSelectionChanged: (selectedItems) {
                        ctrl.filterByBrand(selectedItems);
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: ctrl.productShowInUi.length,
                  itemBuilder: (context, index) {
                    final product = ctrl.productShowInUi[index];
                    return ProductCard(
                      name: product.name ?? 'No name',
                      imageUrl: product.image ?? 'url',
                      price: product.price ?? 0,
                      offerTag: '30% off',
                      onTap: () {
                        Get.to(ProductDescriptionPage(), arguments: {'data': product});
                      },
                      onWishlistTap: () {
                        // Product object ko Map me convert karke wishlist me add karo
                        wishlistCtrl.addToWishlist({
                          'productId': product.id,
                          'name': product.name,
                          'price': product.price,
                          'image': product.image,
                          'category': product.category,
                          'brand': product.brand,
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
