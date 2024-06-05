import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/domain/models/auth.dart';
import 'package:shop/src/ui/screens/auth_screen.dart';
import 'package:shop/src/ui/screens/products_overview_screen.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Text('Ocorreu um erro, tente novamente mais tarde!');
        } else {
          return auth.isAuth
              ? const ProductsOverviewScreen()
              : const AuthScreen();
        }
      },
    );
  }
}
