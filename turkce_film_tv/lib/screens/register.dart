import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/user_service.dart';
import 'homepage.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

  final whiteInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

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

  @override
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
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final baseFontSize = 14.0;
    final scaledFontSize = baseFontSize * textScaleFactor;
    final TextStyle whiteTextStyle = TextStyle(
      color: Colors.white,
      fontSize: scaledFontSize,
    );

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): LeftButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): RightButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): UpButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): DownButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Actions(
                  actions: <Type, Action<Intent>>{
                    DownButtonIntent: CallbackAction<DownButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _emailInputNode!);
                        return null;
                      },
                    ),
                  },
                  child: Focus(
                    focusNode: _usernameInputNode,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        labelStyle: whiteTextStyle,
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                        ),
                        enabledBorder: whiteInputBorder,
                        focusedBorder: whiteInputBorder,
                      ),
                      style: whiteTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Actions(
                  actions: <Type, Action<Intent>>{
                    UpButtonIntent: CallbackAction<UpButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _usernameInputNode!);
                        return null;
                      },
                    ),
                    DownButtonIntent: CallbackAction<DownButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _passwordInputNode!);
                        return null;
                      },
                    ),
                  },
                  child: Focus(
                    focusNode: _emailInputNode,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E- Posta',
                        labelStyle: whiteTextStyle,
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        enabledBorder: whiteInputBorder,
                        focusedBorder: whiteInputBorder,
                      ),
                      style: whiteTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Actions(
                  actions: <Type, Action<Intent>>{
                    UpButtonIntent: CallbackAction<UpButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _emailInputNode!);
                        return null;
                      },
                    ),
                    DownButtonIntent: CallbackAction<DownButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _passwordAgainNode!);
                        return null;
                      },
                    ),
                  },
                  child: Focus(
                    focusNode: _passwordInputNode,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        labelStyle: whiteTextStyle,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        enabledBorder: whiteInputBorder,
                        focusedBorder: whiteInputBorder,
                      ),
                      style: whiteTextStyle,
                      obscureText: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Actions(
                  actions: <Type, Action<Intent>>{
                    UpButtonIntent: CallbackAction<UpButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _passwordInputNode!);
                        return null;
                      },
                    ),
                    DownButtonIntent: CallbackAction<DownButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _registerNode!);
                        return null;
                      },
                    ),
                  },
                  child: Focus(
                    focusNode: _passwordAgainNode,
                    child: TextField(
                      controller: _passwordAgainController,
                      decoration: InputDecoration(
                        labelText: 'Şifre tekrar',
                        labelStyle: whiteTextStyle,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        enabledBorder: whiteInputBorder,
                        focusedBorder: whiteInputBorder,
                      ),
                      style: whiteTextStyle,
                      obscureText: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Actions(
                  actions: <Type, Action<Intent>>{
                    UpButtonIntent: CallbackAction<UpButtonIntent>(
                      onInvoke: (intent) async {
                        await _changeFocus(context, _passwordAgainNode!);
                        return null;
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
                            const SnackBar(
                                content:
                                    Text('Girdiğiniz şifreler aynı değil')),
                          );
                        }
                        return null;
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Girdiğiniz şifreler aynı değil')),
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0), // Adjust the padding as needed
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.green.withOpacity(0.8)),
                        elevation: MaterialStateProperty.all<double>(
                            0.0), // Remove the button shadow
                      ),
                      child: const Text('Kayıt ol'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
