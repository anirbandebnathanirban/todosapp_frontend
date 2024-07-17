import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/task/task.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import '../url.dart';

class TaskProvider extends ChangeNotifier{
  bool isLoading = false;
  double progress = 10.0;
  String? errorMessage;
  List<Task> tasks = [];

  Future<void> getTasks(List<ObjectId> taskIds) async {
    if(taskIds.isEmpty)return;
    isLoading = true;
    progress = 10.0;
    notifyListeners();
    notifyListeners();
    for(ObjectId taskId in taskIds){
      final response = await http.get(
        Uri.parse('$baseURL/api/task/gettask/${taskId.toJson()}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode == status_codes.TASK_FETCHED_SUCCESSFULLY){
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> taskJson = jsonResponse['task'];
        String message = jsonResponse['message'];
        tasks.add(Task.fromJson(taskJson));
        notifyListeners();
        print('message: $message');
      }
      else{
        tasks = [];
        final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        errorMessage = error.message;
        print('message: ${error.message} \n error: ${error.error}');
        break;
      }
    }
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/task/createtask'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(task.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TASK_CREATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> taskJson = jsonResponse['task'];
      String message = jsonResponse['message'];
      tasks.add(Task.fromJson(taskJson));
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> updateTask(int index, Task task) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    ObjectId taskId = task.taskId!;
    final response = await http.put(
      Uri.parse('$baseURL/api/task/updatetask/${taskId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(task.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TASK_UPDATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> taskJson = jsonResponse['updatedTask'];
      String message = jsonResponse['message'];
      tasks[index] = Task.fromJson(taskJson);
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> deleteTask(int index, ObjectId taskId) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.delete(
      Uri.parse('$baseURL/api/task/deletetask/${taskId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TASK_DELETED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'];
      tasks.removeAt(index);
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