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

  // Filters
  String? selectedCategory;
  List<String> selectedBrands = [];
  String searchQuery = ""; // Search query

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
      applyFilters(); // <-- apply filters including search
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

  // Filters
  filterByCategory(String category) {
    selectedCategory = category;
    applyFilters();
  }

  filterByBrand(List<String> brands) {
    selectedBrands = brands;
    applyFilters();
  }

  // Search
  updateSearchQuery(String query) {
    searchQuery = query.toLowerCase();
    applyFilters();
  }

  // Apply filters + search
  void applyFilters() {
    productShowInUi = products.where((product) {
      final matchesCategory =
          selectedCategory == null || product.category == selectedCategory;
      final matchesBrand = selectedBrands.isEmpty ||
          selectedBrands.map((b) => b.toLowerCase()).contains(
              (product.brand ?? "").toLowerCase());
      final matchesSearch = product.name != null &&
          product.name!.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesBrand && matchesSearch;
    }).toList();
    update();
  }

  // Sort
  sortByPrice({required bool ascending}) {
    productShowInUi.sort((a, b) {
      if (ascending) return a.price!.compareTo(b.price!);
      return b.price!.compareTo(a.price!);
    });
    update();
  }
}
