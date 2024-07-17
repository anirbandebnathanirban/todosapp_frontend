import 'package:mongo_dart/mongo_dart.dart';
import 'user_name.dart';

class User{
  ObjectId? userId;
  String username;
  Username userName;
  String userPrimaryEmail;
  List<String>? userSecondaryEmails;
  String userPassword;
  List<String>? userContactNumber;
  List<ObjectId>? userTasks;
  List<ObjectId>? userTeams;

  User({
    this.userId,
    required this.username,
    required this.userName,
    required this.userPrimaryEmail,
    this.userSecondaryEmails,
    required this.userPassword,
    this.userContactNumber,
    this.userTasks,
    this.userTeams,
  });

  Map<String, dynamic> toJson(){
    return {
      '_id' : userId?.toJson(),
      'username' : username,
      'userName' : userName.toJson(),
      'userPrimaryEmail' : userPrimaryEmail,
      'userSecondaryEmails' : userSecondaryEmails,
      'userPassword' : userPassword,
      'userContactNumber' : userContactNumber,
      'userTasks' : userTasks?.map((userTask) => userTask.toJson()).toList(),
      'userTeams' : userTeams?.map((team) => team.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: ObjectId.parse(json['_id']),
      username: json['username'],
      userName: Username.fromJson(json['userName']),
      userPrimaryEmail: json['userPrimaryEmail'], 
      userSecondaryEmails: json['userSecondaryEmails'] != null ? List<String>.from(json['userSecondaryEmails']) : null,
      userPassword: json['userPassword'],
      userContactNumber: json['userContactNumber'] != null ? List<String>.from(json['userContactNumber']) : null,
      userTasks: json['userTasks'] != null
        ? List<ObjectId>.from((json['userTasks'] as List).map((userTask) => ObjectId.parse(userTask))) 
        : null,
      userTeams: json['userTeams'] != null 
        ? List<ObjectId>.from((json['userTeams'] as List).map((userTeam) => ObjectId.parse(userTeam)))
        : null,
    );
  }
}