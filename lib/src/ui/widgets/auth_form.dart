import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/domain/exceptions/auth_exception.dart';
import 'package:shop/src/domain/models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMode authMode = AuthMode.login;
  Map<String, String> authData = {
    'email': '',
    'password': '',
  };

  bool isLogin() => authMode == AuthMode.login;

  bool isSignup() => authMode == AuthMode.signup;

  void switchAuthMode() {
    setState(() {
      isLogin() ? authMode = AuthMode.signup : authMode = AuthMode.login;
    });
  }

  void showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() => isLoading = true);

    formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (isLogin()) {
        await auth.login(authData['email']!, authData['password']!);
      } else {
        await auth.signUp(authData['email']!, authData['password']!);
      }
    } on AuthException catch (error) {
      showErrorDialog(error.toString());
    } catch (error) {
      showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      elevation: 8,
      surfaceTintColor: Colors.white,
      child: Container(
        height: isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('e-mail'),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => authData['email'] = email ?? '',
                validator: (value) {
                  final email = value ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('senha'),
                ),
                obscureText: true,
                controller: passwordController,
                onSaved: (password) => authData['password'] = password ?? '',
                validator: (value) {
                  final password = value ?? '';
                  if (password.isEmpty) return 'Informe uma senha válida';
                  if (password.length < 6) {
                    return 'Sua senha precisa ter 6 ou mais caracteres';
                  }
                  return null;
                },
              ),
              if (isSignup())
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('confirme a senha'),
                  ),
                  obscureText: true,
                  validator: (value) {
                    final password = value ?? '';
                    if (password != passwordController.text) {
                      return 'senhas diferentes';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(isLogin() ? 'Login' : 'Registrar'),
                ),
              const Spacer(),
              TextButton(
                onPressed: switchAuthMode,
                child:
                    Text(isLogin() ? 'Deseja registrar?' : 'Já possui conta?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
