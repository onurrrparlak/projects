import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turkce_film_tv/screens/forgotpassword.dart';
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

  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  final TextStyle whiteTextStyle = TextStyle(
    color: Colors.white,
  );

  final whiteInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

  FocusNode? _loginUpNode;
  FocusNode? _emailInputNode;
  FocusNode? _passwordInputNode;
  FocusNode? _loginButtonNode;
  FocusNode? _forgotPasswordNode;
  FocusNode? _registerButtonNode;

  _setFirstFocus(BuildContext context) {
    if (_loginUpNode == null) {
      _loginUpNode = FocusNode();
      _emailInputNode = FocusNode();
      _passwordInputNode = FocusNode();
      _loginButtonNode = FocusNode();
      _forgotPasswordNode = FocusNode();
      _registerButtonNode = FocusNode();

      FocusScope.of(context).requestFocus(_loginUpNode);
    }
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loginUpNode == null) {
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Text(
                        'Türkçe film izlemek artık daha kolay',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.0220,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Actions(
                            actions: <Type, Action<Intent>>{
                              RightButtonIntent:
                                  CallbackAction<RightButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(
                                      context, _registerButtonNode!);
                                  _pageController.animateToPage(
                                    1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                              DownButtonIntent:
                                  CallbackAction<DownButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _emailInputNode!);
                                  return null;
                                },
                              ),
                            },
                            child: Focus(
                              focusNode: _loginUpNode,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: !(_loginUpNode?.hasFocus ?? false)
                                      ? null
                                      : Border(
                                          bottom: BorderSide(
                                            color: Colors.white,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0020,
                                          ),
                                        ),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    await _changeFocus(context, _loginUpNode!);
                                    _pageController.animateToPage(
                                      0,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: const Text(
                                    'Giriş',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Focus(
                            focusNode: _registerButtonNode,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    !(_registerButtonNode?.hasFocus ?? false)
                                        ? null
                                        : Border(
                                            bottom: BorderSide(
                                              color: Colors.white,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0020,
                                            ),
                                          ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await _changeFocus(
                                      context, _registerButtonNode!);
                                  _pageController.animateToPage(
                                    1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: const Text(
                                  'Kayıt',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          children: [
                            // Giriş page
                            SingleChildScrollView(
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 16.0),
                                  TextField(
                                    controller: _emailController,
                                    focusNode: _emailInputNode,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordInputNode);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'E-Posta',
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
                                  SizedBox(height: 16.0),
                                  TextField(
                                    focusNode: _passwordInputNode,
                                    controller: _passwordController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () async {
                                      try {
                                        await _userService.loginUser(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    },
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
                                  ),
                                  SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                                builder: (context) =>
                                                    const HomePage(),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(e.toString())),
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Adjust the radius as needed
                                            ),
                                          ),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal:
                                                    24.0), // Adjust the padding as needed
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          overlayColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green
                                                      .withOpacity(0.8)),
                                          elevation: MaterialStateProperty.all<
                                                  double>(
                                              0.0), // Remove the button shadow
                                        ),
                                        child: Text(
                                          'Giriş yap',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Şifreni mi unuttun?',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                            // Kayıt page
                            RegisterPage(),
                          ],
                        ),
                      ),
                    ],
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
