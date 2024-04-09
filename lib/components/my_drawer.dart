import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Widget _itemDrawer(IconData icon, String text, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.blueGrey,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Welcome!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          _itemDrawer(
            Icons.home,
            'Store',
            () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.HOME_SCREEN,
            ),
          ),
          const Divider(),
          _itemDrawer(
            Icons.credit_card,
            'Orders',
            () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.ORDERS_SCREEN,
            ),
          ),
          const Divider(),
          _itemDrawer(
            Icons.edit,
            'Manage Products',
            () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.PRODUCTS_SCREEN,
            ),
          ),
        ],
      ),
    );
  }
}
