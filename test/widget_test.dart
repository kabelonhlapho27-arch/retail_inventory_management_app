// Basic tests for the SmartMart Retail Inventory app

import 'package:flutter_test/flutter_test.dart';

import 'package:retail_inventory_management_app/main.dart';
import 'package:retail_inventory_management_app/product_store.dart';

void main() {
  testWidgets('Home screen shows the sample products', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(SmartMartApp(store: ProductStore()..loadSampleData()));

    // App bar title is shown
    expect(find.text('Products'), findsOneWidget);

    // Sample products are listed
    expect(find.text('Coca-Cola 2L'), findsOneWidget);
    expect(find.text('White Bread'), findsOneWidget);
  });

  testWidgets('Tapping a product opens the detail screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(SmartMartApp(store: ProductStore()..loadSampleData()));

    await tester.tap(find.text('Coca-Cola 2L'));
    await tester.pumpAndSettle(); // wait for the page transition

    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('PRD001'), findsOneWidget);
  });
}
