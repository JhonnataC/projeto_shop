import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/src/domain/models/order.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({
    super.key,
    required this.order,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final double itemsHeight = (widget.order.products.length * 24) + 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                'R\$ ${widget.order.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() {
                  _expanded = !_expanded;
                }),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expanded ? itemsHeight : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.order.products.map((prod) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${prod.quantity}x R\$ ${prod.price}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
