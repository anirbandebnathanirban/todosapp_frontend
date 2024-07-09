import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/user/user.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import '../url.dart';

class UserProvider extends ChangeNotifier{
  bool isLoading = false;
  String? errorMessage;
  List<User> users = [];
  User? tempUser;

  Future<void> getAllRegisteredUser() async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/user/getalluser'),
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

  Future<void> getUser(ObjectId userId) async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/user/getuser/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.USER_FOUND_SUCCESSFULLY) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> userJosn = jsonResponse['user'];
      tempUser = User.fromJson(userJosn);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }
}