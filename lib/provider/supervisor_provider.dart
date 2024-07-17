import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/supervisor/supervisor.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import '../url.dart';

class SupervisorProvider extends ChangeNotifier{
  bool isLoading = false;
  double progress = 10.0;
  String? errorMessage;
  List<Supervisor> supervisors = [];

  Future<void> getSupervisors() async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/supervisor/getallsupervisor'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.FETCH_ALL_SUPERVISOR_IS_SUCCESSFUL){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> supervisorsJson = jsonResponse['supervisors'];
      String message = jsonResponse['message'];
      supervisors = supervisorsJson.map((json) => Supervisor.fromJson(json as Map<String, dynamic>)).toList();
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<Supervisor?> getSupervisor(ObjectId supervisorId) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/supervisor/getsupervisor/${supervisorId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_FOUND_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> supervisorJson = jsonResponse['supervisor'];
      String message = jsonResponse['message'];
      print('message: $message');
      return Supervisor.fromJson(supervisorJson);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
      return null;
    }
  }

  Future<void> addSupervisor(Supervisor supervisor) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/supervisor/addsupervisor'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(supervisor.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_ADDED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> supervisorJson = jsonResponse['supervisor'];
      String message = jsonResponse['message'];
      supervisors.add(Supervisor.fromJson(supervisorJson));
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> updateSupervisor(int index, Supervisor supervisor) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    ObjectId supervisorId = supervisor.supervisorId!;
    final response = await http.put(
      Uri.parse('$baseURL/api/supervisor/updatesupervisor/${supervisorId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(supervisor.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_UPDATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> supervisorJson = jsonResponse['updatedSupervisor'];
      String message = jsonResponse['message'];
      supervisors[index] = Supervisor.fromJson(supervisorJson);
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> removeSupervisor(int index, ObjectId supervisorId) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.delete(
      Uri.parse('$baseURL/api/supervisor/deletesupervisor/${supervisorId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_REMOVED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'];
      supervisors.removeAt(index);
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