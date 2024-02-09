import 'package:flutter/material.dart';
import 'package:projeto_shop/components/mt_badge.dart';
import 'package:projeto_shop/components/my_drawer.dart';
import 'package:projeto_shop/components/product_grid.dart';
import 'package:projeto_shop/models/cart.dart';
import 'package:projeto_shop/models/product_list.dart';
import 'package:projeto_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteItems = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.CART_SCREEN),
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (context, cart, child) => MyBadge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteItems = true;
                } else {
                  _showFavoriteItems = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoriteItems),
    );
  }
}
