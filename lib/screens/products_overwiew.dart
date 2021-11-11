import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/products_provider.dart';
import 'package:shop/widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text("Only Favorites"),
                      value: FilterOptions.Favorites,
                    ),
                    const PopupMenuItem(
                      child: Text("Show All"),
                      value: FilterOptions.All,
                    )
                  ])
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
