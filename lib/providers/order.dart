import 'package:flutter/widgets.dart';
import 'package:shopping_arena/providers/cart.dart';

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

  void addOrder(List<Cart> cartProducts, double total) {
    _orders.insert(
      0,
      Order(
          id: DateTime.now().toString(),
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }
}
