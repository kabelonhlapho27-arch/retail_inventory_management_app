// TPG226C Group Project - SmartMart Retail Inventory Management App
// File: product.dart - Product model class, categories, statuses and
//       conversion to/from a products.txt line
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

// Options shown in the category and status dropdowns
const List<String> kCategories = [
  'Beverages',
  'Groceries',
  'Bakery',
  'Dairy',
  'Household',
  'Personal Care',
  'Electronics',
  'Other',
];
const List<String> kStatuses = ['Available', 'Low Stock', 'Out of Stock'];

class Product {
  String productCode;
  String productName;
  String category;
  double price;
  int quantity;
  String status;
  String image;

  Product({
    required this.productCode,
    required this.productName,
    required this.category,
    required this.price,
    required this.quantity,
    required this.status,
    this.image = 'assets/images/placeholder.png',
  });
  //images can load from the assets/images
  //e.g. 'Personal Care' -> assets/images/personal_care.png
  static String imageForCategory(String category) =>
      'assets/images/${category.toLowerCase().replaceAll(' ', '_')}.png';

  // Converts the product to one comma-separated line of products.txt
  String toLine() =>
      '$productCode,$productName,$category,${price.toStringAsFixed(2)},$quantity,$status';

  /// Parses one line of products.txt. Returns null if the line is empty or wrong...
  static Product? fromLine(String line) {
    final parts = line.split(',');
    if (parts.length != 6) return null;
    final price = double.tryParse(parts[3].trim());
    final qty = int.tryParse(parts[4].trim());
    if (price == null || qty == null) return null;
    final category = parts[2].trim();
    return Product(
      productCode: parts[0].trim(),
      productName: parts[1].trim(),
      category: category,
      price: price,
      quantity: qty,
      image: imageForCategory(category),
      status: parts[5].trim(),
    );
  }

  // Colour used to display the stock status
  Color get statusColor {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
