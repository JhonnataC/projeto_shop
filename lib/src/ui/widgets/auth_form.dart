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

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMode authMode = AuthMode.login;
  Map<String, String> authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  // Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    // _slideAnimation = Tween(
    //   begin: const Offset(0, -1.5),
    //   end: const Offset(0, 0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _animationController!,
    //     curve: Curves.linear,
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  bool isLogin() => authMode == AuthMode.login;
  bool isSignup() => authMode == AuthMode.signup;

  void switchAuthMode() {
    setState(() {
      if (isLogin()) {
        authMode = AuthMode.signup;
        _animationController?.forward();
      } else {
        authMode = AuthMode.login;
        _animationController?.reverse();
      }
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
    print(isValid);
    if (!isValid) return;
    print('object');
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        height: isLogin() ? 350 : 470,
        // height: _heightAnimation?.value.height ?? (isLogin() ? 310 : 400),
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
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: isLogin() ? 0 : 60,
                    maxHeight: isLogin() ? 0 : 120,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: TextFormField(
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
                  ),
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
