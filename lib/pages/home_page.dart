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
    final wishlistCtrl = Get.put(WishlistController());

    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async => ctrl.fetchProducts(),
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
              // Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) => ctrl.updateSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              // Categories horizontal
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.productCategories.length,
                  itemBuilder: (context, index) {
                    final cat = ctrl.productCategories[index];
                    return Padding(
                      padding: const EdgeInsets.all(6),
                      child: ChoiceChip(
                        label: Text(cat.name ?? 'Error'),
                        selected: ctrl.selectedCategory == cat.name,
                        onSelected: (_) => ctrl.filterByCategory(cat.name ?? ''),
                      ),
                    );
                  },
                ),
              ),

              // Sort + Brand filters
              Row(
                children: [
                  Expanded(
                    child: DropDownBtn(
                      items: ['Rs : low to high', 'Rs : High to low'],
                      selectedItemText: 'Sort',
                      onSelected: (selected) {
                        ctrl.sortByPrice(
                            ascending: selected == 'Rs : low to high');
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

              // Product grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
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
                      imageUrl: product.image ?? '',
                      price: product.price ?? 0,
                      offerTag: '30% off',
                      onTap: () => Get.to(ProductDescriptionPage(), arguments: {'data': product}),
                      onWishlistTap: () {
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
