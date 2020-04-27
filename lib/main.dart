import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_arena/providers/products_provider.dart';
import 'package:shopping_arena/screens/product_detail.dart';
import 'package:shopping_arena/screens/products_overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Products(),
        // create: (context) => Products(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.indigo, accentColor: Colors.deepOrange),
          home: ProductsOverview(),
          routes: {'/productDetail': (context) => ProductDetail()},
        ));
  }
}
