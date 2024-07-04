import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task/task.dart';
import '../models/task/task_basic_details.dart';
import '../models/task/task_timing_and_schedule.dart';
import '../provider/auth_provider.dart';
import '../provider/task_provider.dart';

class AddTaskScreenSelf extends StatefulWidget {
  
  @override
  _AddTaskScreenSelfState createState() => _AddTaskScreenSelfState();
}

class _AddTaskScreenSelfState extends State<AddTaskScreenSelf>{

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

  void _addTask(BuildContext context) {
    if(taskTitle.isEmpty || taskDescription.isEmpty || taskPriority.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both task title and task description and task priority'),
        ),
      );
    }
    else{
      Provider.of<TaskProvider>(context).createTask(
        Task(
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
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        TextFormField(
          onChanged: (value) {
            taskTitle = value;
          },
          decoration: const InputDecoration(
            label: Text('Title', style: TextStyle(color: Colors.blueAccent)),
            icon: Icon(Icons.text_fields, color: Colors.blueAccent),
          ),
          validator: (value) {
            if(value == null || value.isEmpty){
              return 'task title is required';
            }
            return null;
          },
        ),
        TextFormField(
          onChanged: (value) {
            taskDescription = value;
          },
          decoration: const InputDecoration(
            label: Text('Description', style: TextStyle(color: Colors.blueAccent)),
            icon: Icon(Icons.description, color: Colors.blueAccent),
          ),
        ),
        TextFormField(
          onChanged: (value) {
            taskPriority = value;
          },
          decoration: const InputDecoration(
            label: Text('Priority', style: TextStyle(color: Colors.blueAccent)),
            icon: Icon(Icons.low_priority, color: Colors.blueAccent),
          ),
          validator: (value) {
            if(value == null || value.isEmpty){
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
              controller: TextEditingController(text: startDate.toString().split(' ')[0]),
              decoration: const InputDecoration(
                label: Text('Start Date', style: TextStyle(color: Colors.blueAccent)),
                icon: Icon(Icons.date_range, color: Colors.blueAccent),
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
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
              icon: const Icon(Icons.calendar_month, color: Colors.blueAccent,),
              label: const Text('Select Start Date', style: TextStyle(color: Colors.blueAccent)),
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
              controller: TextEditingController(text: endDate.toString().split(' ')[0]),
              decoration: const InputDecoration(
                label: Text('End Date', style: TextStyle(color: Colors.blueAccent)),
                icon: Icon(Icons.date_range, color: Colors.blueAccent),
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
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
              icon: const Icon(Icons.calendar_month, color: Colors.blueAccent),
              label: const Text('Select Start Date', style: TextStyle(color: Colors.blueAccent)),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) {
                taskDueTime = DateTime.parse(value); 
              },
              controller: TextEditingController(text: dueDate.toString().split(' ')[0]),
              decoration: const InputDecoration(
                label: Text('End Date', style: TextStyle(color: Colors.blueAccent)),
                icon: Icon(Icons.date_range, color: Colors.blueAccent),
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
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
              icon: const Icon(Icons.calendar_month, color: Colors.blueAccent),
              label: const Text('Select Start Date', style: TextStyle(color: Colors.blueAccent)),
            )
          ],
        ),
        TextButton.icon(
          onPressed: () => _addTask(context), 
          icon: const Icon(Icons.task, color: Colors.blueAccent),
          label: const Text('Add Task', style: TextStyle(color: Colors.blueAccent)),
        )
      ],
    );
  }
} 