import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shopping_arena/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoritesProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id, orElse: () => null);
  }

  Future<void> fetchProducts() async {
    final url = "<FIREBASE URL>/products.json";
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (data == null) {
        return;
      }
      data.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl']));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(
      String title, double price, String description, String imageUrl) async {
    final url = "<FIREBASE URL>/products.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': title,
            'price': price,
            'description': description,
            'imageUrl': imageUrl
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: title,
          price: price,
          description: description,
          imageUrl: imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  updateProduct(String id, String title, double price, String description,
      String imageUrl) async {
    final url = "<FIREBASE URL>/products/$id.json";
    await http.patch(url,
        body: json.encode({
          'title': title,
          'price': price,
          'description': description,
          'imageUrl': imageUrl
        }));

    final prodIndex = _items.indexWhere((product) => product.id == id);
    final update = Product(
      id: id,
      title: title,
      price: price,
      description: description,
      imageUrl: imageUrl,
    );
    _items[prodIndex] = update;
    notifyListeners();
  }

  deleteProduct(String id) async {
    final url = "<FIREBASE URL>/products/$id.json";
    await http.delete(url);
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
