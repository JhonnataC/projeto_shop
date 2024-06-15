import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/ui/widgets/my_drawer.dart';
import 'package:shop/src/ui/widgets/order_item.dart';
import 'package:shop/src/domain/models/order_list.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Future<void> refreshOrders(BuildContext context) async {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      drawer: const MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshOrders(context),
        child: FutureBuilder(
          future: Provider.of<OrderList>(context).loadOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return const Center(
                child: Text('Error loading orders'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.itemCount,
                  itemBuilder: (context, i) {
                    return OrderItemWidget(order: orders.items[i]);
                  },            
                ),               
              );
            }
          },
        ),
      ),
    );
  }
}
