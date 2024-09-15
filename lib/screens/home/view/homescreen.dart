import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_structure/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../../provider/product_provider.dart';
import '../../../utils/debouncer.dart';
import '../../cart_screen/view/cart_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = "homeScreen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 800);

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ProductProvider>().loadProducts().catchError((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load products")));
        });
      },
    );
    super.initState();
  }

  void _searchProduct(String value) {
    _debouncer.run(() {
      context.read<ProductProvider>().searchProducts(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, top: 5),
                    child: Icon(Icons.shopping_cart),
                  ),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _searchProduct(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type Product Name',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: 18,
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _searchProduct(searchController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Builder(
            builder: (context) {
              if (productProvider.isProductLoading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              } else {
                return productProvider.filteredProducts.isEmpty
                    ? const Center(
                        child: Text("No products found.."),
                      )
                    : Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.5,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: productProvider.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final item = productProvider.filteredProducts[index];

                              return GridTile(
                                footer: InkWell(
                                  onTap: () {
                                    context.read<CartProvider>().addToCart(item);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Product added..")),
                                      snackBarAnimationStyle: AnimationStyle(
                                        duration: const Duration(
                                          seconds: 1,
                                        ),
                                      ),
                                    );
                                    Navigator.pushNamed(context, CartScreen.routeName);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(color: Colors.black54),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.price.toStringAsFixed(2),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.grey[300]),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 30,
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(color: Colors.black54),
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.title,
                                          maxLines: 1,
                                          style: const TextStyle(color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      Image.network(
                                        item.image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
