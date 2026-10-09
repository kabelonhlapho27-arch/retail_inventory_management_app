import 'package:flutter/material.dart';
import 'package:retail_inventory_management_app/product_store.dart';
import 'home_screen.dart';

void main() {
  runApp(const SmartMartApp());
}

class SmartMartApp extends StatelessWidget {
  const SmartMartApp({super.key});

  @override
  Widget build(BuildContext context) {
final store=ProductStore();
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartMart',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(products: store.products),
    );
  }
}
