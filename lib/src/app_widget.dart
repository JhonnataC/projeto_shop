import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/data/utils/custom_route.dart';
import 'package:shop/src/domain/models/auth.dart';
import 'package:shop/src/domain/models/cart.dart';
import 'package:shop/src/domain/models/order_list.dart';
import 'package:shop/src/domain/models/product_list.dart';
import 'package:shop/src/ui/screens/auth_or_home_screen.dart';
import 'package:shop/src/ui/screens/cart_screen.dart';
import 'package:shop/src/ui/screens/orders_screen.dart';
import 'package:shop/src/ui/screens/product_detail_screen.dart';
import 'package:shop/src/ui/screens/product_form_screen.dart';
import 'package:shop/src/ui/screens/products_screen.dart';
import 'package:shop/src/data/utils/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (context) => ProductList(),
          update: (context, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (context) => OrderList(),
          update: (context, auth, previous) {
            return OrderList(
                auth.token ?? '', auth.userId ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
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
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_OR_HOME_SCREEN: (context) => const AuthOrHome(),
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
