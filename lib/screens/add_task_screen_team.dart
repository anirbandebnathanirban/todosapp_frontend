import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/task/task.dart';
import '../models/task/task_basic_details.dart';
import '../models/task/task_timing_and_schedule.dart';
import '../provider/auth_provider.dart';
import '../provider/task_provider.dart';
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
  DateTime taskCreationTime = DateTime.now();
  DateTime taskStartTime = DateTime.now();
  DateTime taskEndTime = DateTime.now();
  DateTime taskDueTime = DateTime.now();

  DateTime? startDate;
  DateTime? endDate;
  DateTime? dueDate;

  List<AddSupervisor> supervisorFormList = [];
  List<mongo.ObjectId> taskSupervisor = [];

  mongo.ObjectId? taskTeam;
  BigInt? taskEstimatedTime;

  void _addTask(BuildContext context) {
    if (taskTitle.isEmpty || taskDescription.isEmpty || taskPriority.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter both task title and task description and task priority'),
        ),
      );
    } else {
      Provider.of<TaskProvider>(context).createTask(Task(
        taskCreator: Provider.of<AuthProvider>(context).userId!,
        taskTitle: taskTitle,
        taskBasicDetails: Taskbasicdetails(
          taskDescription: taskDescription,
          taskStatus: taskStatus,
          taskPriority: taskPriority,
        ),
        taskTimingAndSchedule: Tasktimingandschedule(
          taskCreationTime: taskCreationTime,
          taskStartTime: taskStartTime,
          taskEndTime: taskEndTime,
          taskDueTime: taskDueTime,
        ),
        taskSupervisor: taskSupervisor,
        taskTeam: taskTeam,
        taskEstimatedTime: taskEstimatedTime,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task (Team)'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          TextFormField(
            onChanged: (value) {
              taskTitle = value;
            },
            controller: TextEditingController(text: taskTitle),
            decoration: const InputDecoration(
              label: Text('Title', style: TextStyle(color: Colors.blueAccent)),
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
              label:
                  Text('Priority', style: TextStyle(color: Colors.blueAccent)),
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
              TextFormField(
                onChanged: (value) {
                  taskStartTime = DateTime.parse(value);
                },
                controller: TextEditingController(
                    text: startDate.toString().split(' ')[0]),
                decoration: const InputDecoration(
                  label: Text('Start Date',
                      style: TextStyle(color: Colors.blueAccent)),
                  icon: Icon(Icons.date_range, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'task start date is required';
                  }
                  return null;
                },
              ),
              TextButton.icon(
                onPressed: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100, 12, 31),
                  );
                  setState(() {
                    startDate = dateTime;
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
              TextFormField(
                onChanged: (value) {
                  taskEndTime = DateTime.parse(value);
                },
                controller: TextEditingController(
                    text: endDate.toString().split(' ')[0]),
                decoration: const InputDecoration(
                  label: Text('End Date',
                      style: TextStyle(color: Colors.blueAccent)),
                  icon: Icon(Icons.date_range, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'task end date is required';
                  }
                  return null;
                },
              ),
              TextButton.icon(
                onPressed: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100, 12, 31),
                  );
                  setState(() {
                    endDate = dateTime;
                  });
                },
                icon:
                    const Icon(Icons.calendar_month, color: Colors.blueAccent),
                label: const Text('Select End Date',
                    style: TextStyle(color: Colors.blueAccent)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: (value) {
                  taskDueTime = DateTime.parse(value);
                },
                controller: TextEditingController(
                    text: dueDate.toString().split(' ')[0]),
                decoration: const InputDecoration(
                  label: Text('Due Date',
                      style: TextStyle(color: Colors.blueAccent)),
                  icon: Icon(Icons.date_range, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'task due date is required';
                  }
                  return null;
                },
              ),
              TextButton.icon(
                onPressed: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100, 12, 31),
                  );
                  setState(() {
                    dueDate = dateTime;
                  });
                },
                icon:
                    const Icon(Icons.calendar_month, color: Colors.blueAccent),
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
                icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                label: const Text('Add Supervisor',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
              ListView.builder(
                  itemCount: supervisorFormList.length,
                  itemBuilder: (context, index) {
                    return supervisorFormList[index];
                  })
            ],
          ),
          AddTeam(),
          TextFormField(
            onChanged: (value) {
              taskEstimatedTime = BigInt.parse(value);
            },
            controller:
                TextEditingController(text: taskEstimatedTime.toString()),
            decoration: const InputDecoration(
              icon: Icon(Icons.punch_clock, color: Colors.blueAccent),
              label: Text('Task Estimation Time(in hours)',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              for (AddSupervisor supervisor in supervisorFormList) {
                taskSupervisor.add(supervisor.supervisorId!);
              }
              taskTeam = AddTeam().teamId;
              _addTask(context);
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
