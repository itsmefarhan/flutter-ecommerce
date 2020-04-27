import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_arena/providers/order.dart';
import 'package:shopping_arena/widgets/drawer.dart';
import 'package:shopping_arena/widgets/order_item.dart' as prefix0;

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: DrawerWidget(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) =>
              prefix0.OrderItem(orderData.orders[index])),
    );
  }
}
