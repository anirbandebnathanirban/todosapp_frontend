import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/user/user.dart';
import '../models/user/user_name.dart';
import '../models/user/user_name.dart';
import '../provider/auth_provider.dart';

class SigninScreen extends StatelessWidget {
  String username = '';
  String userPassword = '';

  void _signinUser(BuildContext context) {
    if (userPassword.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password'),
        ),
      );
    } else {
      Provider.of<AuthProvider>(context).userSignIn(User(
        username: username,
        userName: Username(
          userFirstName: 'dummyFirstName',
          userLastName: 'dummyLastName',
        ),
        userPrimaryEmail: 'test@example.com',
        userPassword: userPassword,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          TextFormField(
            onChanged: (value) {
              username = value;
            },
            controller: TextEditingController(text: username),
            decoration: const InputDecoration(
                icon: Icon(Icons.person, color: Colors.blueAccent),
                label: Text('Enter username',
                    style: TextStyle(color: Colors.blueAccent))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'username is required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              userPassword = value;
            },
            controller: TextEditingController(text: userPassword),
            decoration: const InputDecoration(
              icon: Icon(Icons.password, color: Colors.blueAccent),
              label: Text('Enter password',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              String passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
              if (!RegExp(passwordRegex).hasMatch(value)) {
                return 'Enter a valid Password';
              }
              return null;
            },
          ),
          TextButton.icon(
              onPressed: () {
                _signinUser(context);
              },
              icon: const Icon(Icons.login, color: Colors.blueAccent),
              label: const Text('Sign In',
                  style: TextStyle(color: Colors.blueAccent)))
        ],
      ),
    );
  }
}
