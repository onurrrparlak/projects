import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turkce_film_tv/screens/register.dart';
import '../services/user_service.dart';
import 'homepage.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode? _emailInputNode;
  FocusNode? _passwordInputNode;
  FocusNode? _loginButtonNode;
  FocusNode? _forgotPasswordNode;
  FocusNode? _registerButtonNode;

  _setFirstFocus(BuildContext context) {
    if (_emailInputNode == null) {
      _emailInputNode = FocusNode();
      _passwordInputNode = FocusNode();
      _loginButtonNode = FocusNode();
      _forgotPasswordNode = FocusNode();
      _registerButtonNode = FocusNode();

      FocusScope.of(context).requestFocus(_emailInputNode);
    }
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_emailInputNode == null) {
      _setFirstFocus(context);
    }
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): LeftButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): RightButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): UpButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): DownButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_passwordInputNode);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordInputNode,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () async {
                    try {
                      await _userService.loginUser(
                        _emailController.text,
                        _passwordController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _userService.loginUser(
                        _emailController.text,
                        _passwordController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: const Text('Giriş Yap'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Şifreni mi unuttun?'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text('Kayıt ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
