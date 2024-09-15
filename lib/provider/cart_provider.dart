import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'base_provider.dart';

class CartProvider extends BaseProvider {
  List<Product> _cart = [];
  double _total = 0.0;

  CartProvider(super.context);

  List<Product> get cart => _cart;
  double get total => _total;

  void addToCart(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(product);
    }

    _calculateTotal();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
    }

    _calculateTotal();
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      _cart[index].quantity++;
      _calculateTotal();
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      _calculateTotal();
      notifyListeners();
    }
  }

  void _calculateTotal() {
    _total = 0.0;
    for (Product product in _cart) {
      _total += product.price * product.quantity;
    }
  }

  int getProductQuantity(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      return _cart[index].quantity;
    }
    return 0;
  }
}
