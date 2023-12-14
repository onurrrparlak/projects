import 'package:flutter/material.dart';
import '../services/focusnodeservice.dart';
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
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusService.registerButtonNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    const baseFontSize = 14.0;
    final scaledFontSize = baseFontSize * textScaleFactor;
    final TextStyle whiteTextStyle = TextStyle(
      color: Colors.white,
      fontSize: scaledFontSize,
    );

    return Shortcuts(
      shortcuts: FocusService.shortcuts,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  focusNode: FocusService.registerKullaniciAdiNode,
                  controller: _usernameController,
                  onEditingComplete: () {
                    FocusService.changeFocus(
                        context, FocusService.registerEPostaNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextField(
                  focusNode: FocusService.registerEPostaNode,
                  onEditingComplete: () {
                    FocusService.changeFocus(
                        context, FocusService.registerPasswordNode);
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E- Posta',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextField(
                  focusNode: FocusService.registerPasswordNode,
                  onEditingComplete: () {
                    FocusService.changeFocus(
                        context, FocusService.registerPasswordAgainNode);
                  },
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextField(
                  focusNode: FocusService.registerPasswordAgainNode,
                  onEditingComplete: () async {
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
                            content: Text('Girdiğiniz şifreler aynı değil')),
                      );
                    }
                  },
                  controller: _passwordAgainController,
                  decoration: InputDecoration(
                    labelText: 'Şifre tekrar',
                    labelStyle: whiteTextStyle,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    enabledBorder: whiteInputBorder,
                    focusedBorder: whiteInputBorder,
                  ),
                  style: whiteTextStyle,
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Focus(
                  focusNode: FocusService.registerRegisterButtonNode,
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
                              content: Text('Girdiğiniz şifreler aynı değil')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
