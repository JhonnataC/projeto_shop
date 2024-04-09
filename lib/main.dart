import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_form_screen.dart';
import 'package:shop/screens/products_overview_screen.dart';
import 'package:shop/screens/products_screen.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderList(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
          appBarTheme: ThemeData().appBarTheme.copyWith(
                centerTitle: true,
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.deepPurple,
                secondary: Colors.redAccent,
              ),
          textTheme: ThemeData().textTheme.copyWith(
                bodyLarge: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black,
                  fontSize: 20,
                ),
                bodyMedium: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black,
                  fontSize: 17,
                ),
                bodySmall: const TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.HOME_SCREEN: (context) => const ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailScreen(),
          AppRoutes.CART_SCREEN: (context) => const CartScreen(),
          AppRoutes.ORDERS_SCREEN: (context) => const OrdersScreen(),
          AppRoutes.PRODUCTS_SCREEN: (context) => const ProductsScreen(),
          AppRoutes.PRODUCT_FORM_SCREEN: (context) => const ProductFormScreen(),
        },
      ),
    );
  }
}
