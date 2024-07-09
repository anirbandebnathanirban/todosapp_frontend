import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/user.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import '../url.dart';

class AuthProvider with ChangeNotifier{
  bool isLoading = false;
  bool isSignedIn = false;
  bool isSignedUp = false;
  String? errorMessage;
  User? user;
  ObjectId? userId;

  AuthProvider(){
    _initUser();
  }
  
  Future<void> _initUser() async {
    isLoading = true;
    notifyListeners();
    final token = await getToken();
    if(token == null){
      isLoading = false;
      notifyListeners();
      return;
    }
    isSignedUp = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/auth/getuser'),
      headers: {
        'Authorization' : token,
        'Content-Type': 'application/json',
      }
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.USER_VERIFIED_WITH_AUTHENTICATION_TOKEN){
      isSignedIn = true;
      notifyListeners();
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> userJson = jsonResponse['user'];
      userId = userJson['_id'];
      user = User.fromJson(userJson);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> userSignUp(User user) async {
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.AUTHENTICATION_TOKEN_IS_GENERATED){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['token'];
      await saveToken(token);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> userSignIn(User user) async {
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/signin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.AUTHENTICATION_TOKEN_IS_GENERATED){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['token'];
      await saveToken(token);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}