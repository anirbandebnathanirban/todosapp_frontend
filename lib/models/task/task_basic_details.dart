class Taskbasicdetails{
  String? taskDescription;
  String taskStatus;
  String taskPriority;

  Taskbasicdetails({
    this.taskDescription,
    required this.taskStatus,
    required this.taskPriority,
  });

  Map<String, dynamic> toJson(){
    return {
      'taskDescription' : taskDescription,
      'taskStatus' : taskStatus,
      'taskPriority' : taskPriority,
    };
  }

  factory Taskbasicdetails.fromJson(Map<String, dynamic> json){
    return Taskbasicdetails(
      taskDescription: json['taskDescription'],
      taskStatus: json['taskStatus'], 
      taskPriority: json['taskPriority'],
    );
  }
}