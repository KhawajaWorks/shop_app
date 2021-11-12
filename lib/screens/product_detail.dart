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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProd.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '\$${loadedProd.price}',
            style: const TextStyle(color: Colors.grey, fontSize: 25),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              loadedProd.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ]),
      ),
    );
  }
}
