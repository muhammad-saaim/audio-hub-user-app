import 'package:audio_hub_client/model/product_category/product_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productCategories = [];

  // New filters
  String? selectedCategory;
  List<String> selectedBrands = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProducts);
      productShowInUi.assignAll(products);
      Get.snackbar('Success', 'Products fetched successfully',
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs
          .map((doc) =>
          ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  // category filter
  filterByCategory(String category) {
    selectedCategory = category;
    applyFilters();
  }

  // brand filter
  filterByBrand(List<String> brands) {
    selectedBrands = brands;
    applyFilters();
  }

  // apply both filters together
  void applyFilters() {
    productShowInUi = products.where((product) {
      final matchesCategory =
          selectedCategory == null || product.category == selectedCategory;
      final matchesBrand = selectedBrands.isEmpty ||
          selectedBrands.map((b) => b.toLowerCase()).contains(
              (product.brand ?? "").toLowerCase());
      return matchesCategory && matchesBrand;
    }).toList();
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts = List<Product>.from(productShowInUi);
    sortedProducts.sort((a, b) {
      if (ascending) {
        return a.price!.compareTo(b.price!);
      } else {
        return b.price!.compareTo(a.price!);
      }
    });
    productShowInUi = sortedProducts;
    update();
  }
}
