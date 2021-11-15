import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  var _showFavoritesOnly = false;

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteitems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product fidByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product prod) async {
    final url = Uri.https(
            'my-shop-app-10976-default-rtdb.firebaseio.com', '/products.json')
        .replace(queryParameters: {'auth': authToken});
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'imageUrl': prod.imageUrl,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);
      // _items.add(value);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newprod) async {
    final url = Uri.https('my-shop-app-10976-default-rtdb.firebaseio.com',
            '/products/$id.json')
        .replace(queryParameters: {'auth': authToken});
    try {
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': newprod.title,
              'description': newprod.description,
              'price': newprod.price,
              'imageUrl': newprod.imageUrl,
            },
          ),
        );
        _items[prodIndex] = newprod;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void deleteProduct(String id) async {
    final url = Uri.https('my-shop-app-10976-default-rtdb.firebaseio.com',
            '/products/$id.json')
        .replace(queryParameters: {'auth': authToken});
    final existingprodIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingprodIndex];
    _items.removeAt(existingprodIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingprodIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final Map<String, String> filterparam = filterByUser
        ? {'auth': authToken, 'orderBy': '"creatorId"', 'equalTo': '"$userId"'}
        : {
            'auth': authToken,
          };
    final url = Uri(
            scheme: 'https',
            host: 'my-shop-app-10976-default-rtdb.firebaseio.com',
            path: '/products.json')
        .replace(queryParameters: filterparam);
    try {
      //print(url);
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print(authToken + '*************************');
      final List<Product> loadedProds = [];
      if (extractedData == null) {
        return;
      }
      final url_fav = Uri.https('my-shop-app-10976-default-rtdb.firebaseio.com',
              '/userFavorites/$userId.json')
          .replace(queryParameters: {'auth': authToken});
      final favoriteResponse = await http.get(url_fav);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodID, prodData) {
        loadedProds.add(
          Product(
            id: prodID,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodID] ?? false,
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedProds;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
