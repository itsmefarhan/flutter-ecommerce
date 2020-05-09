import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_arena/providers/cart.dart';
import 'package:shopping_arena/providers/order.dart';
import 'package:shopping_arena/providers/products_provider.dart';
import 'package:shopping_arena/screens/order.dart';
import 'package:shopping_arena/screens/product_detail.dart';
import 'package:shopping_arena/screens/products_overview.dart';
import 'package:shopping_arena/screens/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.indigo, accentColor: Colors.deepOrange),
        home: ProductsOverviewScreen(),
        routes: {
          '/productDetail': (context) => ProductDetailScreen(),
          '/cart': (context) => CartScreen(),
          '/orders': (context) => OrdersScreen()
        },
      ),
    );
  }
}
