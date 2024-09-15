import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../repository/product_repo.dart';
import 'base_provider.dart';

class ProductProvider extends BaseProvider {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  ProductProvider(super.context);

  List<Product> get filteredProducts => _filteredProducts;

  bool _isProductLoading = false;
  bool get isProductLoading => _isProductLoading;
  set isProductLoading(bool val) {
    _isProductLoading = val;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    isProductLoading = true;
    try {
      List<dynamic> productsJson = await ProductRepository().fetchProducts();
      _products = productsJson.map((json) => Product.fromMap(json)).toList();
      _filteredProducts = _products;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load products');
    } finally {
      isProductLoading = false;
    }
  }

  void searchProducts(String query) {
    if (query.trim().isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products.where((product) => product.title.trim().toLowerCase().contains(query.trim().toLowerCase())).toList();
    }
    notifyListeners();
  }


}
