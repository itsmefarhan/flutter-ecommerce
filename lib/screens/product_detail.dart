import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;    
    print(productId);
    return Scaffold(
      appBar: AppBar(title: Text('title')),
    );
  }
}
