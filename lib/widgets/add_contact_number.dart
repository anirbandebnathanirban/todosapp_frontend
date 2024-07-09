import 'package:flutter/material.dart';

class AddContactNumber extends StatelessWidget {
  String contactNumber = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        contactNumber = value;
      },
      controller: TextEditingController(text: contactNumber),
      decoration: const InputDecoration(
        icon: Icon(Icons.call, color: Colors.blueAccent),
        label: Text('Contact Number', style: TextStyle(color: Colors.blueAccent)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty)return null;
        String contactNoRegex = r'\d{3}-\d{3}-\d{4}';
        if(!RegExp(contactNoRegex).hasMatch(value))return 'Enter a valid contact number';
        return null;
      },
    );
  }
}