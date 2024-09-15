import 'package:flutter/material.dart';
import 'package:flutter_provider_structure/provider/base_provider.dart';
import 'package:flutter_provider_structure/provider/cart_provider.dart';
import 'package:flutter_provider_structure/provider/product_provider.dart';
import 'package:flutter_provider_structure/initial_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BaseProvider(context),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(context),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(context),
        ),
      ],
      child: const InitialApp(),
    ),
  );
}
