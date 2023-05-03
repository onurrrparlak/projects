import 'package:flutter/material.dart';
import 'package:turkce_film_tv/screens/loginscreen.dart';

import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  String _username = 'John Doe';
  String? _password;
  String? _passwordAgain;
  String? _selectedAvatar;

  final List<String> _avatars = [
    'assets/images/defaultavatar.png',
    'assets/images/defaultavatar.png',
    'assets/images/defaultavatar.png',
    'assets/images/defaultavatar.png',
  ];

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Perform submit action here
      print('Submitting form:');
      print('Username: $_username');
      print('Password: $_password');
      print('Password Again: $_passwordAgain');
      print('Selected Avatar: $_selectedAvatar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 500,
                child: Row(
                  children: [
                    Text('Kullacını adı:'),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.white,
                          textTheme: TextTheme(
                            subtitle1: TextStyle(color: Colors.white),
                          ),
                        ),
                        child: SizedBox(
                          width: 200,
                          child: TextFormField(
                            initialValue: _username,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            enabled: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Şifre:'),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        } else if (_passwordAgain != null &&
                            value != _passwordAgain) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Şifre tekrar:'),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password Again',
                      ),
                      onChanged: (value) {
                        _passwordAgain = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password again';
                        } else if (_password != null && value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Select an avatar:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _userService.logoutUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Çıkış yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
