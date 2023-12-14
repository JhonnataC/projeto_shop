import 'package:flutter/material.dart';
import 'package:projeto_shop/components/my_drawer.dart';
import 'package:projeto_shop/components/product_item.dart';
import 'package:projeto_shop/models/product_list.dart';
import 'package:projeto_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM_SCREEN),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (context, i) {
            return Column(
              children: [
                ProductItem(product: products.items[i]),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
