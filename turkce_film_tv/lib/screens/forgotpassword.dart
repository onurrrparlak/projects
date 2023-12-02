import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/focusnodeservice.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusService.changeFocus(context, FocusService.forgotPasswordMailNode);
    });
  }

  final TextStyle whiteTextStyle = TextStyle(
    color: Colors.white,
  );

  final whiteInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(38.0),
  );

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  focusNode: FocusService.forgotPasswordMailNode,
                  onEditingComplete: () async {
                    await _resetPassword();
                  },
                  controller: _emailController,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'E-mail adresinizi giriniz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Focus(
                  focusNode: FocusService.forgotPasswordSubmitNode,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Şifre sıfırlama mailini gönder'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
