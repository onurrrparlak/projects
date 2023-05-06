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

  void dispose() {
    super.dispose();
    _emailInputNode?.dispose();
    _passwordInputNode?.dispose();
    _loginButtonNode?.dispose();
    _forgotPasswordNode?.dispose();
    _registerButtonNode?.dispose();
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_emailController == null) {
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
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Actions(
                actions: <Type, Action<Intent>>{
                  DownButtonIntent: CallbackAction<DownButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _passwordInputNode!);
                    },
                  ),
                },
                child: Focus(
                  focusNode: _emailInputNode,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                ),
              ),
              Actions(
                actions: <Type, Action<Intent>>{
                  UpButtonIntent: CallbackAction<UpButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _emailInputNode!);
                    },
                  ),
                  DownButtonIntent: CallbackAction<DownButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _loginButtonNode!);
                    },
                  ),
                },
                child: Focus(
                  focusNode: _passwordInputNode,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Şifre'),
                  ),
                ),
              ),
              Actions(
                actions: <Type, Action<Intent>>{
                  UpButtonIntent: CallbackAction<UpButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _passwordInputNode!);
                    },
                  ),
                  DownButtonIntent: CallbackAction<DownButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _forgotPasswordNode!);
                    },
                  ),
                  EnterButtonIntent: CallbackAction<EnterButtonIntent>(
                    onInvoke: (intent) async {
                      try {
                        await _userService.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                },
                child: Focus(
                  focusNode: _loginButtonNode,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _userService.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    child: Text('Giriş yap'),
                  ),
                ),
              ),
              Actions(
                actions: <Type, Action<Intent>>{
                  UpButtonIntent: CallbackAction<UpButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _loginButtonNode!);
                    },
                  ),
                  EnterButtonIntent: CallbackAction<EnterButtonIntent>(
                    onInvoke: (intent) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                  ),
                  DownButtonIntent: CallbackAction<DownButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _registerButtonNode!);
                    },
                  ),
                },
                child: Focus(
                  focusNode: _forgotPasswordNode,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Şifremi unuttum'),
                  ),
                ),
              ),
              Actions(
                actions: <Type, Action<Intent>>{
                  UpButtonIntent: CallbackAction<UpButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _forgotPasswordNode!);
                    },
                  ),
                  EnterButtonIntent: CallbackAction<EnterButtonIntent>(
                    onInvoke: (intent) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                  ),
                },
                child: Focus(
                  focusNode: _forgotPasswordNode,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text('Hemen kayıt ol'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
