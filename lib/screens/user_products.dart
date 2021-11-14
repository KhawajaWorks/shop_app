import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/products_provider.dart';
import 'package:shop/screens/edit_product.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              try {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              } catch (error) {
                scaffold.showSnackBar(
                    const SnackBar(content: Text('Deleting Failed')));
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  productData.items[i].id,
                  productData.items[i].title,
                  productData.items[i].imageUrl,
                ),
                const Divider(),
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
