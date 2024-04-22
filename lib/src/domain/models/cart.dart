import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shop/src/domain/models/cart_item_model.dart';
import 'package:shop/src/domain/models/product.dart';


class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (oldItem) => CartItem(
          id: oldItem.id,
          productId: oldItem.id,
          name: oldItem.name,
          quantity: oldItem.quantity + 1,
          price: oldItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (oldItem) => CartItem(
          id: oldItem.id,
          productId: oldItem.id,
          name: oldItem.name,
          quantity: oldItem.quantity - 1,
          price: oldItem.price,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
