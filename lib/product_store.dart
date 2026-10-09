//Holds product list and loads/saves product.txt
import "product.dart";

class ProductStore {
  final List<Product> products = [];

  static const List<String> _sample = [
    'PRD001,Coca-Cola 2L,Beverages,24.99,35,Available',
    'PRD002,White Bread,Bakery,18.50,12,Available',
    'PRD003,Fresh Milk 2L,Dairy,32.99,4,Low Stock',
    'PRD004,Washing Powder 2kg,Household,79.99,0,Out of Stock',
    'PRD005,USB Keyboard,Electronics,199.99,8,Available',
    ];

  ProductStore(){
    loadInitialData();
  }

void loadInitialData(){
  for(var line in _sample){
    final product = Product.fromLine(line);
    if(product != null){
      products.add(product);
    }
  }
}
  
}
