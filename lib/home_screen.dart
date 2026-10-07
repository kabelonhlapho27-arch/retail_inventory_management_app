import 'package:flutter/material.dart';

import 'add_product_screen.dart';
import 'product_details_creen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required List<dynamic> products});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [];

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products.removeAt(index);
                });
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: products.isEmpty
          ? const Center(child: Text('No products available'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  child: ListTile(
                    //product image
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(product['image']),
                    ),

                    //product name
                    title: Text(
                      product['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    //product code and price
                    subtitle: Text(
                      'Code: ${product['code']}\n'
                      'Price: \$${product['price'].toStringAsFixed(2)}',
                    ),

                    //stock status
                    trailing: Text(
                      product['stock'] > 0 ? 'In Stock' : 'Out of Stock',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: product['stock'] > 0 ? Colors.green : Colors.red,
                      ),
                    ),

                    //Tap to view details
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },

                    //Long press to delete
                    onLongPress: () {
                      confirmDelete(index);
                    },
                  ),
                );
              },
            ),

            //add product button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
          // Navigate to add product screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
