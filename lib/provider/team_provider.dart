import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart'; 
import '../models/team/team.dart';
import '../models/error.dart';
import './status_codes.dart' as status_codes;
import './auth_provider.dart';
import '../url.dart';

class TeamProvider extends ChangeNotifier{
  bool isLoading = false;
  String? errorMessage;
  List<Team> teams = [];

  Future<void> getTeams(List<ObjectId> teamIds) async {
    isLoading = true;
    notifyListeners();
    for(ObjectId teamId in teamIds){
      final response = await http.get(
        Uri.parse('$baseURL/api/team/getteam/$teamId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      isLoading = false;
      notifyListeners();
      if(response.statusCode == status_codes.TEAM_FOUND_SUCCESSFULLY){
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> teamJson = jsonResponse['team'];
        teams.add(Team.fromJson(teamJson));
      }
      else{
        teams = [];
        final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        errorMessage = error.message;
        break;
      }
    }
    notifyListeners();
  }

  Future<void> createTeam(Team team) async {
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      Uri.parse('$baseURL/api/team/createteam'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(team.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TEAM_CREATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> teamJson = jsonResponse['team'];
      teams.add(Team.fromJson(teamJson));
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> updateTeam(int index, Team team) async {
    isLoading = true;
    notifyListeners();
    ObjectId? teamId = team.teamId;
    final response = await http.put(
      Uri.parse('$baseURL/api/team/updateteam/$teamId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(team.toJson()),
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TEAM_UPDATED_SUCCESSFULLY){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> teamJson = jsonResponse['updatedTeam'];
      teams[index] = Team.fromJson(teamJson);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }

  Future<void> deleteTeam(int index, ObjectId taskId) async {
    isLoading = true;
    notifyListeners();
    final response = await http.delete(
      Uri.parse('$baseURL/api/team/deleteteam/$taskId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isLoading = false;
    notifyListeners();
    if(response.statusCode == status_codes.TEAM_DELETED_SUCCESSFULLY){
      teams.removeAt(index);
    }
    else{
      final error = Error.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      errorMessage = error.message;
    }
    notifyListeners();
  }
}