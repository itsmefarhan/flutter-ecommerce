import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shopping_arena/providers/cart.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url = "<FIREBASE URL>/orders.json";
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      Order(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = "<FIREBASE URL>/orders.json";
    final response = await http.get(url);
    final List<Order> loadedOrders = [];
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    if (responseBody == null) {
      return;
    }
    responseBody.forEach((key, value) {
      loadedOrders.add((Order(
          id: key,
          amount: value['amount'],
          dateTime: DateTime.parse(value['dateTime']),
          products: (value['products'] as List<dynamic>).map((item) {
            Cart(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title']);
          }).toList())));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
