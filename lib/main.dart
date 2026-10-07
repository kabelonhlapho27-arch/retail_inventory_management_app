import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const SmartMartApp());
}

class SmartMartApp extends StatelessWidget {
  const SmartMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartMart',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(products: []),
    );
  }
}
