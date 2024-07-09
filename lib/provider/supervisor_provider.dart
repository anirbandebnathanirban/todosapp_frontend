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
  String? errorMessage;
  List<Supervisor> supervisors = [];

  Future<void> getSupervisors() async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/supervisor/getallsupervisor'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.FETCH_ALL_SUPERVISOR_IS_SUCCESSFUL){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<Map<String, dynamic>> supervisorsJson = jsonResponse['supervisors'];
      supervisors = supervisorsJson.map((json) => Supervisor.fromJson(json)).toList();
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<Supervisor?> getSupervisor(ObjectId supervisorId) async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('$baseURL/api/supervisor/getsupervisor/$supervisorId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_FOUND_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> supervisorJson = jsonResponse['supervisor'];
      return Supervisor.fromJson(supervisorJson);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      return null;
    }
  }

  Future<void> addSupervisor(Supervisor supervisor) async {
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/supervisor/addsupervisor'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(supervisor.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_ADDED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> supervisorJson = jsonResponse['supervisor'];
      supervisors.add(Supervisor.fromJson(supervisorJson));
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> updateSupervisor(int index, Supervisor supervisor) async {
    isLoading = true;
    notifyListeners();
    ObjectId? supervisorId = supervisor.supervisorId;
    final response = await http.put(
      Uri.parse('$baseURL/api/supervisor/updatesupervisor/$supervisorId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(supervisor.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_UPDATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> supervisorJson = jsonResponse['updatedSupervisor'];
      supervisors[index] = Supervisor.fromJson(supervisorJson);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> removeSupervisor(int index, ObjectId supervisorId) async {
    isLoading = true;
    notifyListeners();
    final response = await http.delete(
      Uri.parse('$baseURL/api/supervisor/deletesupervisor/$supervisorId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.SUPERVISOR_REMOVED_SUCCESSFULLY){
      supervisors.removeAt(index);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }
}