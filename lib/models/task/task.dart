import 'package:mongo_dart/mongo_dart.dart';
import 'task_basic_details.dart';
import 'task_timing_and_schedule.dart';

class Task{
  ObjectId? taskId;
  ObjectId taskCreator;
  String taskTitle;
  Taskbasicdetails taskBasicDetails;
  Tasktimingandschedule taskTimingAndSchedule;
  List<ObjectId>? taskSupervisor;
  ObjectId? taskTeam;
  BigInt? taskEstimatedTime;

  Task({
    this.taskId,
    required this.taskCreator,
    required this.taskTitle,
    required this.taskBasicDetails,
    required this.taskTimingAndSchedule,
    this.taskSupervisor,
    this.taskTeam,
    this.taskEstimatedTime,
  });

  Map<String, dynamic> toJson(){
    return {
      '_id' : taskId?.toJson(),
      'taskCreator' : taskCreator.toJson(),
      'taskTitle' : taskTitle,
      'taskBasicDetails' : taskBasicDetails.toJson(),
      'taskTimingAndSchedule' : taskTimingAndSchedule.toJson(),
      'taskSupervisor' : taskSupervisor!.map((supervisor) => supervisor.toJson()).toList(),
      'taskTeam' : taskTeam?.toJson(),
      'taskEstimatedTime' : taskEstimatedTime?.toString(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json){
    return Task(
      taskId: ObjectId.parse(json['_id']),
      taskCreator: ObjectId.parse(json['taskCreator']),
      taskTitle: json['taskTitle'],
      taskBasicDetails: Taskbasicdetails.fromJson(json['taskBasicDetails']), 
      taskTimingAndSchedule: Tasktimingandschedule.fromJson(json['taskTimingAndSchedule']),
      taskSupervisor: json['taskSupervisor'] != null 
        ? List<ObjectId>.from((json['taskSupervisor'] as List).map((taskSupervisor) => ObjectId.parse(taskSupervisor)))
        : null,
      taskTeam: ObjectId.parse(json['taskTeam']),
      taskEstimatedTime: BigInt.parse(json['taskEstimatedTime']),
    );
  }
}