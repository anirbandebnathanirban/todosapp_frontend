import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user/user.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;

class UserProvider extends ChangeNotifier{
  bool isLoading = true;
  String? errorMessage;
  List<User> users = [];

  UserProvider() {
    _initAllRegisteredUser();
  }

  Future<void> _initAllRegisteredUser() async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('/api/user/getalluser'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.FETCH_ALL_USERS_IS_SUCCESSFUL){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<Map<String, dynamic>> usersJson = jsonResponse['users'];
      users = usersJson.map((json) => User.fromJson(json)).toList();
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }
}