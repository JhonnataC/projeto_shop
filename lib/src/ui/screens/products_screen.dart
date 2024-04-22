import 'package:flutter/material.dart';
import 'package:shop/src/ui/widgets/my_drawer.dart';
import 'package:shop/src/ui/widgets/product_item.dart';
import 'package:shop/src/domain/models/product_list.dart';
import 'package:shop/src/data/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  Future<void> refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

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
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
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
      ),
    );
  }
}
