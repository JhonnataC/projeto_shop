import 'package:flutter/material.dart';
import 'package:projeto_shop/models/cart.dart';
import 'package:projeto_shop/models/cart_item_model.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItem({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => Provider.of<Cart>(context, listen: false)
          .removeItem(cartItem.productId),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    cartItem.price.toString(),
                  ),
                ),
              ),
            ),
            title: Text(cartItem.name),
            subtitle: Text(
              'Total: R\$ ${cartItem.price * cartItem.quantity}',
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: Text('x${cartItem.quantity}'),
          ),
        ),
      ),
    );
  }
}
