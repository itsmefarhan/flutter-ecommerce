import 'package:flutter/material.dart';
import 'package:shopping_arena/screens/products_overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.indigo, accentColor: Colors.deepOrange),
      home: ProductsOverview(),
    );
  }
}
