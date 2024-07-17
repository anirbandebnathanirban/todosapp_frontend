import 'package:mongo_dart/mongo_dart.dart';
import './team_basic_details.dart';
import './team_mettings.dart';

class Team{
  ObjectId? teamId;
  String teamName;
  Teambasicdetails teamBasicDetails;
  List<ObjectId> teamMembers;
  ObjectId teamLeader;
  List<ObjectId>? teamTasks;
  List<Teammettings>? teamMettings;
  
  Team({
    this.teamId,
    required this.teamName,
    required this.teamBasicDetails,
    required this.teamMembers,
    required this.teamLeader,
    this.teamTasks,
    this.teamMettings,
  });

  Map<String, dynamic> toJson(){
    return {
      '_id' : teamId?.toJson(),
      'teamName' : teamName,
      'teamBasicDetails' : teamBasicDetails.toJson(),
      'teamMembers' : teamMembers.map((teamMember) => teamMember.toJson()).toList(),
      'teamLeader' : teamLeader.toJson(),
      'teamTasks' : teamTasks?.map((teamTask) => teamTask.toJson()).toList(),
      'teamMettings' : teamMettings?.map((metting) => metting.toJson()).toList(),
    };
  }

  factory Team.fromJson(Map<String, dynamic> json){
    return Team(
      teamId: ObjectId.parse(json['_id']),
      teamName: json['teamName'], 
      teamBasicDetails: Teambasicdetails.fromJson(json['teamBasicDetails']), 
      teamMembers: List<ObjectId>.from((json['teamMembers'] as List).map((teamMember) => ObjectId.parse(teamMember))),
      teamLeader: ObjectId.parse(json['teamLeader']),
      teamTasks: json['teamTasks'] != null 
        ? List<ObjectId>.from((json['teamTasks'] as List).map((teamTask) => ObjectId.parse(teamTask)))
        : null,
      teamMettings: json['teamMettings'] != null 
        ? List<Teammettings>.from((json['teamMettings'] as List).map((teamMetting) => Teammettings.fromJson(teamMetting)))
        : null,
    );
  }
}