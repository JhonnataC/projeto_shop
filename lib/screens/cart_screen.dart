import 'package:flutter/material.dart';
import 'package:projeto_shop/components/cart_item.dart';
import 'package:projeto_shop/models/cart.dart';
import 'package:projeto_shop/models/order_list.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = Provider.of<Cart>(context).items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Total', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Provider.of<OrderList>(context, listen: false)
                          .addOrder(cart);
                      cart.clear();
                    },
                    child: const Text(
                      'COMPRAR',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  CartItemWidget(cartItem: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}
