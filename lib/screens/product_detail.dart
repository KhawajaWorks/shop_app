import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final loadedProd = Provider.of<Products>(
      context,
      listen: false,
    ).fidByID(productid);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProd.title),
      ),
      body: Container(),
    );
  }
}
