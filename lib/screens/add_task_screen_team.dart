import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:todos_app_branch/widgets/loading.dart';
import '../models/task/task.dart';
import '../models/task/task_basic_details.dart';
import '../models/task/task_timing_and_schedule.dart';
import '../provider/auth_provider.dart';
import '../provider/task_provider.dart';
import '../provider/supervisor_provider.dart';
import '../provider/team_provider.dart';
import '../provider/user_provider.dart';
import '../widgets/add_supervisor.dart';
import '../widgets/add_team.dart';

class AddTaskScreenTeam extends StatefulWidget {
  @override
  _AddTaskScreenTeamState createState() => _AddTaskScreenTeamState();
}

class _AddTaskScreenTeamState extends State<AddTaskScreenTeam> {
  String taskTitle = '';
  String taskDescription = '';
  String taskStatus = 'Pending';
  String taskPriority = '';
  DateTime? taskStartTime;
  DateTime? taskEndTime;
  DateTime? taskDueTime;

  List<AddSupervisor> supervisorFormList = [AddSupervisor()];
  List<mongo.ObjectId>? taskSupervisor;

  AddTeam taskTeamForm = AddTeam();
  mongo.ObjectId? taskTeam;

  BigInt? taskEstimatedTime;

  void _addTask(TaskProvider taskProvider, AuthProvider authProvider,
      BuildContext context) {
    if (taskTitle.isEmpty ||
        taskDescription.isEmpty ||
        taskPriority.isEmpty ||
        taskStartTime == null ||
        taskDueTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter both task title, description, priority, start date, due date'),
        ),
      );
    } else if (authProvider.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unauthorized User'),
        ),
      );
    } else {
      taskProvider.createTask(Task(
        taskCreator: authProvider.userId!,
        taskTitle: taskTitle,
        taskBasicDetails: Taskbasicdetails(
          taskDescription: taskDescription,
          taskStatus: taskStatus,
          taskPriority: taskPriority,
        ),
        taskTimingAndSchedule: Tasktimingandschedule(
          taskCreationTime: DateTime.now(),
          taskStartTime: taskStartTime!,
          taskEndTime: taskEndTime,
          taskDueTime: taskDueTime!,
        ),
        taskSupervisor: taskSupervisor,
        taskTeam: taskTeam,
        taskEstimatedTime: taskEstimatedTime,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context);
    final supervisorProvider =
        Provider.of<SupervisorProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task (TeamWork)'),
      ),
      body: taskProvider.isLoading
          ? Loading()
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                TextFormField(
                  onChanged: (value) {
                    taskTitle = value;
                  },
                  controller: TextEditingController(text: taskTitle),
                  decoration: const InputDecoration(
                    label: Text('Title',
                        style: TextStyle(color: Colors.blueAccent)),
                    icon: Icon(Icons.text_fields, color: Colors.blueAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'task title is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onChanged: (value) {
                    taskDescription = value;
                  },
                  controller: TextEditingController(text: taskDescription),
                  decoration: const InputDecoration(
                    label: Text('Description',
                        style: TextStyle(color: Colors.blueAccent)),
                    icon: Icon(Icons.description, color: Colors.blueAccent),
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    taskPriority = value;
                  },
                  controller: TextEditingController(text: taskPriority),
                  decoration: const InputDecoration(
                    label: Text('Priority',
                        style: TextStyle(color: Colors.blueAccent)),
                    icon: Icon(Icons.low_priority, color: Colors.blueAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task Priority is required';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          taskStartTime =
                              value.isNotEmpty ? DateTime.parse(value) : null;
                        },
                        controller: TextEditingController(
                            text:
                                taskStartTime?.toString().split(' ')[0] ?? ''),
                        decoration: const InputDecoration(
                          label: Text('Start Date',
                              style: TextStyle(color: Colors.blueAccent)),
                          icon:
                              Icon(Icons.date_range, color: Colors.blueAccent),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'task start date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100, 12, 31),
                        );
                        setState(() {
                          taskStartTime = dateTime;
                        });
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      ),
                      label: const Text('Select Start Date',
                          style: TextStyle(color: Colors.blueAccent)),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          print(value.isNotEmpty);
                          taskEndTime =
                              value.isNotEmpty ? DateTime.parse(value) : null;
                        },
                        controller: TextEditingController(
                            text: taskEndTime?.toString().split(' ')[0] ?? ''),
                        decoration: const InputDecoration(
                          label: Text('End Date',
                              style: TextStyle(color: Colors.blueAccent)),
                          icon:
                              Icon(Icons.date_range, color: Colors.blueAccent),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'task end date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100, 12, 31),
                        );
                        setState(() {
                          taskEndTime = dateTime;
                        });
                      },
                      icon: const Icon(Icons.calendar_month,
                          color: Colors.blueAccent),
                      label: const Text('Select End Date',
                          style: TextStyle(color: Colors.blueAccent)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          print(value.isNotEmpty);
                          taskDueTime =
                              value.isNotEmpty ? DateTime.parse(value) : null;
                        },
                        controller: TextEditingController(
                            text: taskDueTime?.toString().split(' ')[0] ?? ''),
                        decoration: const InputDecoration(
                          label: Text('Due Date',
                              style: TextStyle(color: Colors.blueAccent)),
                          icon:
                              Icon(Icons.date_range, color: Colors.blueAccent),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'task due date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100, 12, 31),
                        );
                        setState(() {
                          taskDueTime = dateTime;
                        });
                      },
                      icon: const Icon(Icons.calendar_month,
                          color: Colors.blueAccent),
                      label: const Text('Select Start Date',
                          style: TextStyle(color: Colors.blueAccent)),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          supervisorFormList.add(AddSupervisor());
                        });
                      },
                      icon: const Icon(Icons.add_circle,
                          color: Colors.blueAccent),
                      label: const Text('Add Supervisor',
                          style: TextStyle(color: Colors.blueAccent)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: supervisorFormList.length,
                      itemBuilder: (context, index) {
                        return supervisorFormList[index];
                      },
                    ),
                  ],
                ),
                taskTeamForm,
                TextFormField(
                  onChanged: (value) {
                    taskEstimatedTime =
                        BigInt.tryParse(value) ?? taskEstimatedTime;
                  },
                  controller: TextEditingController(
                      text: taskEstimatedTime?.toString() ?? ''),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.punch_clock, color: Colors.blueAccent),
                    label: Text('Task Estimation Time(in hours)',
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    List<mongo.ObjectId> tempTaskSupervisor = [];
                    for (AddSupervisor supervisor in supervisorFormList) {
                      if (supervisor.supervisorId != null) {
                        tempTaskSupervisor.add(supervisor.supervisorId!);
                      }
                    }
                    if (tempTaskSupervisor.isNotEmpty) {
                      taskSupervisor = tempTaskSupervisor;
                    }
                    _addTask(taskProvider, authProvider, context);
                  },
                  icon: const Icon(Icons.task, color: Colors.blueAccent),
                  label: const Text('Add Task',
                      style: TextStyle(color: Colors.blueAccent)),
                )
              ],
            ),
    );
  }
}
