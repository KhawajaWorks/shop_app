import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../models/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;
  Future _obtianOrder() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtianOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error occurred'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
