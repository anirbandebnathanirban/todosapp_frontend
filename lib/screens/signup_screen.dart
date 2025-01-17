import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user/user.dart';
import '../models/user/user_name.dart';
import '../provider/auth_provider.dart';
import '../widgets/add_secondary_email.dart';
import '../widgets/add_contact_number.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String username = '';
  String userFirstName = '';
  String userMiddleName = '';
  String userLastName = '';
  String userPrimaryEmail = '';

  List<AddSecondaryEmail> secondaryEmailFormList = [AddSecondaryEmail()];
  List<String>? userSecondaryEmails;

  String userPassword = '';

  List<AddContactNumber> contactNumberFormList = [AddContactNumber()];
  List<String>? userContactNumber;

  void _signupUser(BuildContext context) {
    if (username.isEmpty ||
        userFirstName.isEmpty ||
        userLastName.isEmpty ||
        userPrimaryEmail.isEmpty ||
        userPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter both username, Name of User, Primary Email and Password'),
        ),
      );
    } else {
      Provider.of<AuthProvider>(context, listen: false).userSignUp(User(
        username: username,
        userName: Username(
            userFirstName: userFirstName,
            userMiddleName: userMiddleName,
            userLastName: userLastName),
        userPrimaryEmail: userPrimaryEmail,
        userSecondaryEmails: userSecondaryEmails,
        userPassword: userPassword,
        userContactNumber: userContactNumber,
        userTasks: [],
        userTeams: [],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
              label:
                  Text('username', style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'username is required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              userFirstName = value;
            },
            controller: TextEditingController(text: userFirstName),
            decoration: const InputDecoration(
              icon: Icon(Icons.person, color: Colors.blueAccent),
              label: Text('User First Name',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'User First Name is required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              userMiddleName = value;
            },
            controller: TextEditingController(text: userMiddleName),
            decoration: const InputDecoration(
              icon: Icon(Icons.person, color: Colors.blueAccent),
              label: Text('User Middle Name',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
          ),
          TextFormField(
            onChanged: (value) {
              userLastName = value;
            },
            controller: TextEditingController(text: userLastName),
            decoration: const InputDecoration(
              icon: Icon(Icons.person, color: Colors.blueAccent),
              label: Text('User Last Name',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'User Last Name is required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              userPrimaryEmail = value;
            },
            controller: TextEditingController(text: userPrimaryEmail),
            decoration: const InputDecoration(
              icon: Icon(Icons.email, color: Colors.blueAccent),
              label: Text('User Primary Email',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'User Primary Email is required';
              }
              String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
              if (!RegExp(emailRegex).hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      secondaryEmailFormList.add(AddSecondaryEmail());
                    });
                  },
                  icon: const Icon(Icons.add_box, color: Colors.blueAccent),
                  label: const Text('Add Secondary Email',
                      style: TextStyle(color: Colors.blueAccent))),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: secondaryEmailFormList.length,
                itemBuilder: (context, index) {
                  return secondaryEmailFormList[index];
                },
              ),
            ],
          ),
          TextFormField(
            onChanged: (value) {
              userPassword = value;
            },
            obscureText: true,
            controller: TextEditingController(text: userPassword),
            decoration: const InputDecoration(
              icon: Icon(Icons.password, color: Colors.blueAccent),
              label:
                  Text('Password', style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'password is required';
              }
              String passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
              if (!RegExp(passwordRegex).hasMatch(value)) {
                return 'Enter a valid Password';
              }
              return null;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    contactNumberFormList.add(AddContactNumber());
                  });
                },
                icon: const Icon(Icons.add_box, color: Colors.blueAccent),
                label: const Text('Add Contact Number',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contactNumberFormList.length,
                itemBuilder: (context, index) {
                  return contactNumberFormList[index];
                },
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {
              List<String> tempUserSecondaryEmails = [];
              List<String> tempUserContactNumber = [];
              for (AddSecondaryEmail secondaryEmail in secondaryEmailFormList) {
                if(secondaryEmail.secondaryEmail.isNotEmpty){
                  tempUserSecondaryEmails.add(secondaryEmail.secondaryEmail);
                }
              }
              if(tempUserSecondaryEmails.isNotEmpty){
                userSecondaryEmails = tempUserSecondaryEmails;
              }
              for (AddContactNumber contactNumber in contactNumberFormList) {
                if(contactNumber.contactNumber.isNotEmpty){
                  tempUserContactNumber.add(contactNumber.contactNumber);
                }
              }
              if(tempUserContactNumber.isNotEmpty){
                userContactNumber = tempUserContactNumber;
              }
              _signupUser(context);
            },
            icon: const Icon(Icons.logout, color: Colors.blueAccent),
            label: const Text('Sign Up',
                style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
    );
  }
}
