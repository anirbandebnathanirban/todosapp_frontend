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
  double progress = 10.0;
  String? errorMessage;
  List<User> users = [];
  User? tempUser;

  Future<void> getAllRegisteredUser() async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/user/getalluser'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.FETCH_ALL_USERS_IS_SUCCESSFUL){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> usersJson = jsonResponse['users'];
      String message = jsonResponse['message'];
      users = usersJson.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> getUser(ObjectId userId) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/user/getuser/${userId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.USER_FOUND_SUCCESSFULLY) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> userJosn = jsonResponse['user'];
      String message = jsonResponse['message'];
      tempUser = User.fromJson(userJosn);
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');  
    }
    notifyListeners();
  }
}