import 'package:flutter/material.dart';
import 'package:flutter_provider_structure/screens/cart_screen/view/cart_view.dart';
import 'package:flutter_provider_structure/screens/home/view/homescreen.dart';

class InitialApp extends StatefulWidget {
  const InitialApp({Key? key}) : super(key: key);

  @override
  State<InitialApp> createState() => _InitialAppState();
}

class _InitialAppState extends State<InitialApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        CartScreen.routeName: (context) =>     const CartScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}
