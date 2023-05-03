import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/user_service.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  FocusNode? _usernameInputNode;
  FocusNode? _emailInputNode;
  FocusNode? _passwordInputNode;
  FocusNode? _passwordAgainNode;
  FocusNode? _registerNode;
  FocusNode? _goBackNode;

  _setFirstFocus(BuildContext context) {
    if (_emailInputNode == null) {
      _emailInputNode = FocusNode();
      _usernameInputNode = FocusNode();
      _passwordInputNode = FocusNode();
      _passwordAgainNode = FocusNode();
      _registerNode = FocusNode();
      _goBackNode = FocusNode();

      FocusScope.of(context).requestFocus(_usernameInputNode);
    }
  }

  void dispose() {
    super.dispose();
    _emailInputNode?.dispose();
    _passwordInputNode?.dispose();
    _usernameInputNode?.dispose();
    _passwordAgainNode?.dispose();
    _registerNode?.dispose();
    _goBackNode?.dispose();
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_usernameInputNode == null) {
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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Actions(
                actions: <Type, Action<Intent>>{
                  DownButtonIntent: CallbackAction<DownButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _emailInputNode!);
                    },
                  ),
                },
                child: Focus(
                  focusNode: _usernameInputNode,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Kullanıcı adı'),
                  ),
                ),
              ),
              Actions(
                actions: <Type, Action<Intent>>{
                  UpButtonIntent: CallbackAction<UpButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _usernameInputNode!);
                    },
                  ),
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
                    decoration: InputDecoration(labelText: 'E-posta'),
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
                      await _changeFocus(context, _passwordAgainNode!);
                    },
                  ),
                },
                child: Focus(
                  focusNode: _passwordInputNode,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Şifre'),
                    obscureText: false,
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
                      await _changeFocus(context, _registerNode!);
                    },
                  ),
                },
                child: Focus(
                  focusNode: _passwordAgainNode,
                  child: TextField(
                    controller: _passwordAgainController,
                    decoration: InputDecoration(labelText: 'Şifre Tekrar'),
                    obscureText: false,
                  ),
                ),
              ),
              Actions(
                actions: <Type, Action<Intent>>{
                  UpButtonIntent: CallbackAction<UpButtonIntent>(
                    onInvoke: (intent) async {
                      await _changeFocus(context, _passwordAgainNode!);
                    },
                  ),
                  EnterButtonIntent: CallbackAction<EnterButtonIntent>(
                    onInvoke: (intent) async {
                      if (_passwordController.text ==
                          _passwordAgainController.text) {
                        try {
                          await _userService.registerUser(
                            _emailController.text,
                            _passwordController.text,
                            _usernameController.text,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Girdiğiniz şifreler aynı değil')),
                        );
                      }
                    },
                  ),
                },
                child: Focus(
                  focusNode: _registerNode,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_passwordController.text ==
                          _passwordAgainController.text) {
                        try {
                          await _userService.registerUser(
                            _emailController.text,
                            _passwordController.text,
                            _usernameController.text,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Girdiğiniz şifreler aynı değil')),
                        );
                      }
                    },
                    child: Text('Kayıt ol'),
                  ),
                ),
              ),
              ElevatedButton(onPressed: () {}, child: Text('Geri Dön'))
            ],
          ),
        ),
      ),
    );
  }
}
