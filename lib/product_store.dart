import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'product.dart';

class ProductStore {
  final List<Product> products = [];

  static const List<String> _sample = [
    'PRD001,Coca-Cola 2L,Beverages,24.99,35,Available',
    'PRD002,White Bread,Bakery,18.50,12,Available',
    'PRD003,Fresh Milk 2L,Dairy,32.99,4,Low Stock',
    'PRD004,Washing Powder 2kg,Household,79.99,0,Out of Stock',
    'PRD005,USB Keyboard,Electronics,199.99,8,Available',
  ];

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/products.txt');
  }

  // Read products.txt on startup (create it with sample data if missing)
  Future<void> load() async {
    final file = await _getFile();
    products.clear();
    if (!await file.exists()) {
      loadSampleData();
      await save();
      return;
    }
    for (final line in await file.readAsLines()) {
      final product = Product.fromLine(line);
      if (product != null) products.add(product);
    }
  }

  // Rewrite products.txt after every add, edit or delete
  Future<void> save() async {
    final file = await _getFile();
    await file.writeAsString(products.map((p) => p.toLine()).join('\n'));
  }

  void loadSampleData() {
    products.clear();
    for (final line in _sample) {
      final product = Product.fromLine(line);
      if (product != null) products.add(product);
    }
  }
}