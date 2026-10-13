// TPG226C Group Project - SmartMart Retail Inventory Management App
// File: home_screen.dart - Product List screen: ListView of products,
//       search, add (FAB), view details (tap) and delete (long-press)
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

import 'product.dart';
import 'product_store.dart';

import 'package:flutter/material.dart';

import 'add_product_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final ProductStore store;
  const HomeScreen({super.key, required this.store});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // The store's product list (changes here are saved with store.save())
  late List<Product> products;
  // Text typed in the search box, in lowercase
  String _search = '';

  @override
  void initState() {
    super.initState();
    products = widget.store.products;
  }

  // Asks the user to confirm, then deletes the product and saves the file
  void confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete ${product.productName}?',
          ),
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
                  products.remove(product);
                });
                widget.store.save();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Products matching the search box (name or code)
    final visible = products
        .where(
          (p) =>
              p.productName.toLowerCase().contains(_search) ||
              p.productCode.toLowerCase().contains(_search),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        // Search box under the title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or code',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _search = value.trim().toLowerCase());
              },
            ),
          ),
        ),
      ),
      // Show a message if there is nothing to list, otherwise the products
      body: visible.isEmpty
          ? Center(
              child: Text(
                products.isEmpty
                    ? 'No products available'
                    : 'No products match your search',
              ),
            )
          : ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final product = visible[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    //product image (box icon if the image is missing)
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green.shade200,
                      child: ClipOval(
                        child: Image.asset(
                          product.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.inventory_2,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),

                    //product name
                    title: Text(
                      product.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    //product code and price
                    subtitle: Text(
                      'Code: ${product.productCode}\nPrice: R${product.price.toStringAsFixed(2)}',
                    ),

                    //stock status
                    trailing: Text(
                      product.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: product.statusColor,
                      ),
                    ),

                    //Tap to view details
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                      // The details screen returns 'delete' or the edited product
                      if (result == 'delete') {
                        setState(() {
                          products.remove(product);
                        });
                        widget.store.save();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product deleted')),
                        );
                      } else if (result is Product) {
                        setState(() {
                          final i = products.indexOf(product);
                          products[i] = result;
                        });
                        widget.store.save();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product updated')),
                        );
                      }
                    },

                    //Long press to delete
                    onLongPress: () {
                      confirmDelete(product);
                    },
                  ),
                );
              },
            ),

      //add product button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push<Product>(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(
                // Lets the form reject a code that is already in use
                existingCodes: products.map((p) => p.productCode).toList(),
              ),
            ),
          );
          if (newProduct == null) return; // user pressed Cancel
          setState(() {
            products.add(newProduct);
          });
          widget.store.save();
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Product added')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
