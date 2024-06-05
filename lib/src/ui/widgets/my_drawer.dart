import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/data/utils/app_routes.dart';
import 'package:shop/src/domain/models/auth.dart';

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
              AppRoutes.AUTH_OR_HOME_SCREEN,
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
          const Divider(),
          _itemDrawer(
            Icons.exit_to_app,
            'Exit',
            () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_OR_HOME_SCREEN,
              );
            },
          ),
        ],
      ),
    );
  }
}
