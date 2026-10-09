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
  late List<Product> products;
  String _search = '';

  @override
  void initState() {
    super.initState();
    products = widget.store.products;
  }

  void confirmDelete(Product product) {
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
        .where((p) =>
            p.productName.toLowerCase().contains(_search) ||
            p.productCode.toLowerCase().contains(_search))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
      body: visible.isEmpty
          ? Center(
              child: Text(products.isEmpty
                  ? 'No products available'
                  : 'No products match your search'),
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
                    //product image
                    isThreeLine: true,
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green.shade200,
                      backgroundImage: AssetImage(product.image),
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
