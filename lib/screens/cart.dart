import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_arena/providers/cart.dart';
import 'package:shopping_arena/providers/order.dart';
import 'package:shopping_arena/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                          color: cart.items.length == 0
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                    ),
                    onPressed: cart.items.length == 0
                        ? () {}
                        : () {
                            Provider.of<OrdersProvider>(context, listen: false)
                                .addOrder(cart.items.values.toList(),
                                    cart.totalAmount);
                            cart.clearCart();

                            Navigator.pop(context);
                          },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) => CartItem(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price),
            ),
          )
        ],
      ),
    );
  }
}
