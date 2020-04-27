import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_arena/providers/products_provider.dart';
import 'package:shopping_arena/widgets/product_item.dart';

class ProductsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Arena')),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        itemBuilder: (context, index) => ProductItem(
          id: loadedProducts[index].id,
          title: loadedProducts[index].title,
          imageUrl: loadedProducts[index].imageUrl,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
      ),
    );
  }
}
