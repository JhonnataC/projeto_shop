import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/src/domain/exceptions/http_exception.dart';
import 'package:shop/src/domain/models/product.dart';
import 'package:shop/src/data/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([this._token = '', this._userId = '', this._items = const []]);

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final response = await http
        .get(Uri.parse('${Constants.productsUrlBase}.json?auth=$_token'));
    if (response.body == 'null') return;
    _items.clear();

    final favResponse = await http.get(
        Uri.parse('${Constants.favoritesUrlBase}/$_userId.json?auth=$_token'));

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productsUrlBase}.json?auth=$_token'),
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    // indexWhere retorna um inteiro, no caso, o index onde ocorre a tal condicao
    // caso nao encontre nada que siga a condicao, ela irá retornar -1.
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productsUrlBase}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.productsUrlBase}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw MyHttpException(
          msg: 'Unable to delete product',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
