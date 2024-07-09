import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/task/task.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import './auth_provider.dart';
import '../url.dart';

class TaskProvider extends ChangeNotifier{
  bool isLoading = false;
  String? errorMessage;
  List<Task> tasks = [];

  Future<void> getTasks(List<ObjectId> taskIds) async {
    isLoading = true;
    notifyListeners();
    for(ObjectId taskId in taskIds){
      final response = await http.get(
        Uri.parse('$baseURL/api/task/gettask/$taskId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode == status_codes.TASK_FETCHED_SUCCESSFULLY){
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> taskJson = jsonResponse['task'];
        tasks.add(Task.fromJson(taskJson));
      }
      else{
        tasks = [];
        final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        errorMessage = error.message;
        break;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/task/createtask'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(task.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TASK_CREATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> taskJson = jsonResponse['task'];
      tasks.add(Task.fromJson(taskJson));
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> updateTask(int index, Task task) async {
    isLoading = true;
    notifyListeners();
    ObjectId? taskId = task.taskId;
    final response = await http.put(
      Uri.parse('$baseURL/api/task/updatetask/$taskId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(task.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TASK_UPDATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> taskJson = jsonResponse['task'];
      tasks[index] = Task.fromJson(taskJson);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> deleteTask(int index, ObjectId taskId) async {
    isLoading = true;
    notifyListeners();
    final response = await http.delete(
      Uri.parse('$baseURL/api/task/deletetask/$taskId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TASK_DELETED_SUCCESSFULLY){
      tasks.removeAt(index);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }
}