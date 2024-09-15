import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "cartScreen";

  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),

      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('No items in cart'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: product.image.isNotEmpty ? Image.network(product.image, fit: BoxFit.cover) : const Icon(Icons.image),
                    ),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16 , overflow: TextOverflow.ellipsis),
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)} X ${product.quantity} ',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    subtitle: SizedBox(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              cartProvider.decreaseQuantity(product);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${product.quantity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              cartProvider.increaseQuantity(product);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      // Total price display
      bottomNavigationBar: SafeArea(
        child: Card(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${cartProvider.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
