import 'product.dart'
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

void _confirmDelete(BuildContext context){
  showDialog(context: context, builder:(context)=>AlertDialog(
    title: Text('Delete Product'),
    content: Text('Are you sure you want to delete this product?'),
    actions:[
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text ('Cancel'),
      ),
      TextButton(onPressed: (){
        Navigator.pop(context);
        Navigator.pop(context, 'delete');
      },
      child: Text('Delete',style: TextStyle(color:Colors.red),),
     ),
    ],
  ),
);
}
  Color _getStatusColor(String status){
    switch(status){
      case 'Available':
        return Colors.green;
      case 'Lock Stock':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
     appBar:AppBar(
       title: const Text('Product Details'),
     ),
      body:Padding (padding: const EdgeInsets.all(16.0),
     child:Column(
       children:[
         Card(
           child: Padding(padding: const EdgeInsets.all(16.0),
            child:Column(
              children:[
                Image.asset(product.image,
                 height:150,
                 errorBuilder:(context,error,stackTrace)=>
                 const Icon(Icons.image,size:100),          
                 ),
                const SizedBox(height:16),
                Text(
                  product.productName,
                  style: const TextStyle(fontSize:32,fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text('Product Code:'),
                    Text(product.productCode),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children:[
                    const Text('Category'),
                    Text(product.category),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text('Price:'),
                    Text('R${product.price.toStringAsFixed(2)}'),
                  ],
                ),
                const Sizedbox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spacBetween,
                  children:[
                    const Text('Quantity:'),
                    Text('${product.quantity}'),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment:MainaxisAlignment.spaceBetween,
                  children:[
                    const Text('Status:'),
                    Text(
                      product.status,
                      style: TextStyle(
                        color: _getStatusColor(product.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
           ),
         ),
         const SizedBox(height : 20,),
         Row(
           mainAxisAlignment : mainAxisAlignment.spaceEvenly,
           children:[
             ElevatedButton(onPressed: (){
               //Navigate to edit Screen 
             },
             child:Text('Edit'),
             ),
             ElevatedButton(
               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
               onPressed:(){
                 _confirmdelete(context);
               },child:const Text('Delete',style: TextStyle(color:Colors.white),))
           ],
         )
       ],
     ),              
    ),
    );
  }
}
