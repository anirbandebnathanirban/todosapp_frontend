import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/user.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import '../url.dart';
import './task_provider.dart';

class AuthProvider with ChangeNotifier{
  bool isLoading = false;
  bool isSignedIn = false;
  bool isSignedUp = false;
  double progress = 10.0;
  String? errorMessage;
  User? user;
  ObjectId? userId;

  AuthProvider() {
    _initUser();
  }
  
  Future<void> _initUser() async {
    isLoading = true;
    notifyListeners();
    progress = 100.0;
    notifyListeners();
    final token = await getToken();
    print(token);
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
    // progress = 100.0;
    // notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.USER_VERIFIED_WITH_AUTHENTICATION_TOKEN){
      isSignedIn = true;
      notifyListeners();
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> userJson = jsonResponse['user'];
      String message = jsonResponse['message'];
      user = User.fromJson(userJson);
      userId = user!.userId;
      print(user!.userTasks); 
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
      if(errorMessage == 'user does not exist'){
        isSignedUp = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future<void> userSignUp(User user) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.AUTHENTICATION_TOKEN_IS_GENERATED){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> userJson = jsonResponse['user'];
      String token = jsonResponse['token'];
      String message = jsonResponse['message'];
      this.user = User.fromJson(userJson);
      userId = this.user!.userId;
      await saveToken(token);
      isSignedUp = true;
      isSignedIn = true;
      notifyListeners();
      print('message: $message \n token: $token');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> userSignIn(User user) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/signin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.AUTHENTICATION_TOKEN_IS_GENERATED){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> userJson = jsonResponse['user'];
      String token = jsonResponse['token'];
      String message = jsonResponse['message'];
      this.user = User.fromJson(userJson);
      userId = this.user!.userId;
      await saveToken(token);
      isSignedIn = true;
      print('message: $message \n token: $token');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
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