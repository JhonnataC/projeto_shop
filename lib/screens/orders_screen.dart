import 'package:flutter/material.dart';
import 'package:projeto_shop/components/my_drawer.dart';
import 'package:projeto_shop/components/order_item.dart';
import 'package:projeto_shop/models/order_list.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderList orderList = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      drawer: const MyDrawer(),
      body: ListView.builder(
        itemCount: orderList.itemCount,
        itemBuilder: (context, i) {
          return OrderItemWidget(order: orderList.items[i]);
        },
      ),
    );
  }
}
