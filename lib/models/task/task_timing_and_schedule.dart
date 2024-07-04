class Tasktimingandschedule{
  DateTime taskCreationTime;
  DateTime taskStartTime;
  DateTime? taskEndTime;
  DateTime taskDueTime;

  Tasktimingandschedule({
    required this.taskCreationTime,
    required this.taskStartTime,
    this.taskEndTime,
    required this.taskDueTime,
  });

  Map<String, dynamic> toJson(){
    return {
      'taskCreationTime' : taskCreationTime.toString(),
      'taskStartTime' : taskStartTime.toString(),
      'taskEndTime' : taskEndTime.toString(),
      'taskDueTime' : taskDueTime.toString(),
    };
  }

  factory Tasktimingandschedule.fromJson(Map<String, dynamic> json){
    return Tasktimingandschedule(
      taskCreationTime: DateTime.parse(json['taskCreationTime']), 
      taskStartTime: DateTime.parse(json['taskStartTime']), 
      taskEndTime: DateTime.parse(json['taskEndTime']),
      taskDueTime: DateTime.parse(json['taskDueTime'])
    );
  }
}