// TPG226C Group Project - SmartMart Retail Inventory Management App
// File: main.dart - app entry point; loads products.txt and starts the app
//
// Group members:
//   220048471 - Kyle van Aswegen
//   224037409 - Mlungiso Njoko
//   224002222 - Kabelo Nhlapo
//   219005935 - Rainier Bezuidenhout
//   224069913 - Mobakeng Mochwaro
//   223068452 - Nathaniël Stanley
//   224136508 - Owami Maphalala
//   224042163 - Philasande Simelane

import 'package:flutter/material.dart';
import 'package:retail_inventory_management_app/product_store.dart';

import 'home_screen.dart';

Future<void> main() async {
  // Needed so the file plugin can be used before runApp
  WidgetsFlutterBinding.ensureInitialized();
  // Load the saved products before showing the app
  final store = ProductStore();
  await store.load();
  runApp(SmartMartApp(store: store));
}

// Root widget - sets the app theme and opens the home screen
class SmartMartApp extends StatelessWidget {
  final ProductStore store;

  const SmartMartApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartMart',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(store: store),
    );
  }
}
