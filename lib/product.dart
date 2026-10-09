
//Product model

import 'package:flutter/material.dart';

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
    this.image= 'assets/images/placeholder.png',
  });
   //images can load from the assets/images
  static String imageForCategory(String category) =>
      'assets/images/${category.toLowerCase().replaceAll(' ', '_')}.png';
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

  Color statusColor(String status) {
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


