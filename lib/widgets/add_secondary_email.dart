import 'package:flutter/material.dart';

class AddSecondaryEmail extends StatelessWidget {
  String secondaryEmail = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        secondaryEmail = value;
      },
      controller: TextEditingController(text: secondaryEmail),
      decoration: const InputDecoration(
        icon: Icon(Icons.email, color: Colors.blueAccent),
        label: Text('Secondary Email', style: TextStyle(color: Colors.blueAccent)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty)return null;
        String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
        if(!RegExp(emailRegex).hasMatch(value))return 'Enter a valid email address';
        return null;
      },
    );
  }
}