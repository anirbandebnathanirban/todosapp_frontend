import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart'; 
import '../models/team/team.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import '../url.dart';

class TeamProvider extends ChangeNotifier{
  bool isLoading = false;
  double progress = 10.0;
  String? errorMessage;
  List<Team> teams = [];

  Future<void> getTeams(List<ObjectId> teamIds) async {
    if(teamIds.isEmpty)return;
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    for(ObjectId teamId in teamIds){
      final response = await http.get(
        Uri.parse('$baseURL/api/team/getteam/${teamId.toJson()}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      notifyListeners();
      if(response.statusCode == status_codes.TEAM_FOUND_SUCCESSFULLY){
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> teamJson = jsonResponse['team'];
        String message = jsonResponse['message'];
        teams.add(Team.fromJson(teamJson));
        print('message: $message');
      }
      else{
        teams = [];
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

  Future<void> createTeam(Team team) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/team/createteam'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(team.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TEAM_CREATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> teamJson = jsonResponse['team'];
      String message = jsonResponse['message'];
      teams.add(Team.fromJson(teamJson));
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> updateTeam(int index, Team team) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    ObjectId teamId = team.teamId!;
    final response = await http.put(
      Uri.parse('$baseURL/api/team/updateteam/${teamId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(team.toJson()),
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TEAM_UPDATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> teamJson = jsonResponse['updatedTeam'];
      String message = jsonResponse['message'];
      teams[index] = Team.fromJson(teamJson);
      print('message: $message');
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
      print('message: ${error.message} \n error: ${error.error}');
    }
    notifyListeners();
  }

  Future<void> deleteTeam(int index, ObjectId taskId) async {
    isLoading = true;
    notifyListeners();
    progress = 10.0;
    notifyListeners();
    final response = await http.delete(
      Uri.parse('$baseURL/api/team/deleteteam/${taskId.toJson()}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    progress = 100.0;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TEAM_DELETED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'];
      teams.removeAt(index);
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