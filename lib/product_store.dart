// TPG226C Group Project - SmartMart Retail Inventory Management App
// File: product_store.dart - holds the product list and reads/writes
//       products.txt using dart:io
//
// Group members:
//   220048471 - Kyle van Aswegen
//   224037409 - Mlungiso Njoko
//   224002222 - Kabelo Nhlapo
//   219005935 - Rainier Bezuidenhout
//   224069913 - Mobakeng Mochwaro
//   223068452 - Nathaniël Stanley
//   224136508 - Owami Maphalala
//   224042164 - Philasande Simelane

import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'product.dart';

class ProductStore {
  final List<Product> products = [];

  // Sample products used the first time the app runs (products.txt format)
  static const List<String> _sample = [
    'PRD001,Coca-Cola 2L,Beverages,24.99,35,Available',
    'PRD002,White Bread,Bakery,18.50,12,Available',
    'PRD003,Fresh Milk 2L,Dairy,32.99,4,Low Stock',
    'PRD004,Washing Powder 2kg,Household,79.99,0,Out of Stock',
    'PRD005,USB Keyboard,Electronics,199.99,8,Available',
  ];

  // Read data on startup (creates it with sample data if missing)
  Future<void> load() async {
    products.clear();
    List<String> lines = [];

    if (kIsWeb) {
      //  CHROME STORAGE RUNTIME
      final prefs = await SharedPreferences.getInstance();
      lines = prefs.getStringList('products_data') ?? [];
      
      // If web storage is completely empty, populate it with sample data first
      if (lines.isEmpty) {
        lines = List.from(_sample);
        await prefs.setStringList('products_data', lines);
      }
    } else {
      // ANDROID EMULATOR &  WINDOWS DESKTOP
      try {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/products.txt');

        if (await file.exists()) {
          lines = await file.readAsLines();
        } else {
          // If the text file is missing, write sample data to it
          await file.writeAsString(_sample.join('\n'));
          lines = List.from(_sample);
        }
      } catch (e) {
        print("Error reading products.txt file: $e");
      }
    }

    // Safely parse lines into Product objects for all platforms
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final product = Product.fromLine(line);
      if (product != null) products.add(product);
    }
  }

  // Save data back to the persistent layer
  Future<void> save() async {
    // Convert current product list back to the custom line-by-line format
    final List<String> linesToSave = products.map((p) => p.toLine()).toList();

    if (kIsWeb) {
      //  CHROME STORAGE RUNTIME
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('products_data', linesToSave);
      print("Saved data successfully to Chrome LocalStorage.");
    } else {
      //  ANDROID EMULATOR & WINDOWS
      try {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/products.txt');
        await file.writeAsString(linesToSave.join('\n'));
        print("Saved data successfully to products.txt.");
      } catch (e) {
        print("Error writing to products.txt file: $e");
      }
    }
  }

  // Replace the list with the sample products manually if needed
  void loadSampleData() {
    products.clear();
    for (final line in _sample) {
      final product = Product.fromLine(line);
      if (product != null) products.add(product);
    }
  }
}
