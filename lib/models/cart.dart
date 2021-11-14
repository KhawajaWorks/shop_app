import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmmount {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );

    return total;
  }

  void addItem(
    String productID,
    double price,
    String title,
  ) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price));
    } else {
      _items.putIfAbsent(
          productID,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID].quantity > 1) {
      _items.update(
          productID,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              quantity: cartItem.quantity - 1,
              price: cartItem.price));
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
