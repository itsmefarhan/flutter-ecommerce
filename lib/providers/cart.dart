import 'package:flutter/widgets.dart';

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cart(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class CartProvider with ChangeNotifier {
  // map every cart item with id of product
  Map<String, Cart> _items = {};

  //getter
  Map<String, Cart> get items {
    return {..._items};
  }

  // get num of items
  int get itemCount {
    return _items.length;
  }

  // calculate total cart amount
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // add item to cart
  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // update cart
      _items.update(
          productId,
          (existingItem) => Cart(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity + 1));
    } else {
      // add new item
      _items.putIfAbsent(
          productId,
          () => Cart(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingItem) => Cart(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity - 1,
              price: existingItem.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
