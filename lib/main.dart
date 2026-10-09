import 'package:flutter/material.dart';
import 'package:retail_inventory_management_app/product_store.dart';

import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = ProductStore();
  await store.load();
  runApp(SmartMartApp(store: store));
}

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
