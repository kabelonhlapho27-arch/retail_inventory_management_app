import 'product.dart';
import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'product_details_creen.dart';

class HomeScreen extends StatefulWidget {
  final List<Product> products;
  const HomeScreen({super.key, required this.products});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> products ;

  @override
  void initState(){
    super.initState();
    products = widget.products;
  }
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
              child: const Text('Delete',style: TextStyle(color:Colors.red),),
            ),
          ],
        );
      },
    );
  }
Color _getStatusColor(String status){
  switch(status){
    case 'Available':
      return Colors.green;
    case 'Low Stock':
      return Colors.orange;
    default:
      return Colors.red;
  }
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
                      backgroundColor:Colors.green.shade200,
                      backgroundImage: AssetImage(product.image),
                    ),

                    //product name
                    title: Text(
                      product.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    //product code and price
                    subtitle: Text(
                      'Code: ${product.productCode}\n Price: R${product.price.toStringAsFixed(2)}',
                    ),

                    //stock status
                    trailing: Text(
                      product.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(product.status),
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
                      if(result == 'delete'){
                        setState((){
                          products.removeAt(index);
                        });
                      }
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
