// TPG226C Group Project - SmartMart Retail Inventory Management App
// File: widget_test.dart - widget tests for the product list and
//       detail screen (uses the sample data, not products.txt)
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

import 'package:flutter_test/flutter_test.dart';

import 'package:retail_inventory_management_app/main.dart';
import 'package:retail_inventory_management_app/product_store.dart';

void main() {
  testWidgets('Home screen shows the sample products', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SmartMartApp(store: ProductStore()..loadSampleData()),
    );

    // App bar title is shown
    expect(find.text('Products'), findsOneWidget);

    // Sample products are listed
    expect(find.text('Coca-Cola 2L'), findsOneWidget);
    expect(find.text('White Bread'), findsOneWidget);
  });

  testWidgets('Tapping a product opens the detail screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SmartMartApp(store: ProductStore()..loadSampleData()),
    );

    await tester.tap(find.text('Coca-Cola 2L'));
    await tester.pumpAndSettle(); // wait for the page transition

    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('PRD001'), findsOneWidget);
  });
}
