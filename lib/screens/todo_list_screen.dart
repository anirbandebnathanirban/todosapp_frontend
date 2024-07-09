import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/task_item.dart';
import '../models/task/task.dart';
import '../models/task/task_basic_details.dart';
import '../models/task/task_timing_and_schedule.dart';
import '../models/supervisor/supervisor.dart';
import '../provider/task_provider.dart';
import '../provider/supervisor_provider.dart';
import '../provider/auth_provider.dart';
import '../provider/screen_provider.dart';
import '../widgets/loading.dart';

class TodoListScreen extends StatefulWidget {

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isExpandAddTask = false;
  bool isExpandFilterTask = false;
  bool isExpandTeamTask = false;
  bool isExpandTaskSupervisor = false;
  List<Task> tasks = [];

  void updateTask(BuildContext context, int index, String taskTitle, String? taskDescription, String taskStatus, String taskPriority, DateTime taskCreationTime, DateTime taskStartTime, DateTime? taskEndTime, DateTime taskDueTime){
    Provider.of<TaskProvider>(context).updateTask(index, Task(
      taskCreator: Provider.of<AuthProvider>(context).userId!, 
      taskTitle: taskTitle, 
      taskBasicDetails:  Taskbasicdetails(
        taskDescription: taskDescription,
        taskStatus: taskStatus,
        taskPriority: taskPriority
      ),
      taskTimingAndSchedule: Tasktimingandschedule(
        taskCreationTime: taskCreationTime,
        taskStartTime: taskStartTime, 
        taskEndTime: taskEndTime,
        taskDueTime: taskDueTime,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    var supervisorProvider = Provider.of<SupervisorProvider>(context);
    var screenProvider = Provider.of<ScreenProvider>(context);
    if(taskProvider.isLoading || supervisorProvider.isLoading || screenProvider.isLoading) {
      return const Loading();
    }
    else{
      tasks = taskProvider.tasks;
      return Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.clamp,
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      icon: const Icon(Icons.menu, color: Colors.black),
                    ),
                    const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                  ],
                )
              ),
              ExpansionTile(
                onExpansionChanged: (value) {
                  setState(() {
                    isExpandAddTask = value;
                  });
                },
                leading: isExpandAddTask ? const Icon(Icons.remove_circle, color: Colors.amber) : const Icon(Icons.add_circle, color: Colors.blueAccent),
                title: const Text('Add Task', style: TextStyle(color: Colors.blueAccent)),
                children: [
                  ListTile(
                    leading: const Icon(Icons.align_vertical_bottom, color: Colors.purpleAccent),
                    title: const Text('Create Task for me(self)', style: TextStyle(color: Colors.lightBlue)),
                    onTap: () {
                      Navigator.of(context).pushNamed('/addtaskself');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.align_vertical_bottom, color: Colors.purpleAccent),
                    title: const Text('Create Task with Team Members(TeamWork)', style: TextStyle(color: Colors.lightBlue)),
                    onTap: () {
                      Navigator.of(context).pushNamed('/addtaskteam');
                    },
                  ),
                ],
              ),
              ExpansionTile(
                onExpansionChanged: (value) {
                  setState(() {
                    isExpandFilterTask = value;
                  });
                },
                leading: isExpandFilterTask ? const Icon(Icons.filter_list, color: Colors.amber) : const Icon(Icons.filter_list_alt, color: Colors.blueAccent),
                title: const Text('Fliter Task', style: TextStyle(color: Colors.blueAccent)),
                children: [
                  ListTile(
                    leading: const Icon(Icons.filter_1, color: Colors.purpleAccent),
                    title: const Text('Today', style: TextStyle(color: Colors.lightBlue)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter_2, color: Colors.purpleAccent),
                    title: const Text('Tommorow', style: TextStyle(color: Colors.lightBlue),),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter_3, color: Colors.purpleAccent),
                    title: const Text('Next 7 day', style: TextStyle(color: Colors.lightBlue),),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter_4, color: Colors.purpleAccent),
                    title: const Text('Next 30 day', style: TextStyle(color: Colors.lightBlue),),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter_4, color: Colors.purpleAccent),
                    title: const Text('Filter By Date', style: TextStyle(color: Colors.lightBlue),),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context, 
                        firstDate: DateTime.now(), 
                        lastDate: DateTime(2100, 12, 31),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blueAccent),
                title: const Text('Add Supervisor', style: TextStyle(color: Colors.blueAccent)),
                onTap: () {},
              ),
              ExpansionTile(
                onExpansionChanged: (value) {
                  setState(() {
                    isExpandTeamTask = value;
                  });
                },
                leading: isExpandTeamTask ? const Icon(Icons.group_remove, color: Colors.amber) : const Icon(Icons.group, color: Colors.blueAccent),
                title: const Text('Team', style: TextStyle(color: Colors.blueAccent)),
                children: [
                  ListTile(
                    leading: const Icon(Icons.align_horizontal_center, color: Colors.purpleAccent),
                    title: const Text('Add Team', style: TextStyle(color: Colors.purpleAccent)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.align_horizontal_center, color: Colors.purpleAccent),
                    title: const Text('Show Teams', style: TextStyle(color: Colors.purpleAccent)),
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('To-Do List'),
        ),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskItem(
              task: tasks[index],
              onChanged: (taskStatus) {
                tasks[index].taskBasicDetails.taskStatus = taskStatus;
                taskProvider.updateTask(index, tasks[index]);
              },
              details: (Task task) {
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Task Details', style: TextStyle(color: Colors.blueAccent)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: TextEditingController(text: task.taskTitle),
                            decoration: const InputDecoration(
                              label: Text('Title', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.text_fields, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskBasicDetails.taskDescription),
                            decoration: const InputDecoration(
                              label: Text('Description', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.description, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskBasicDetails.taskStatus),
                            decoration: const InputDecoration(
                              label: Text('Status', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.stacked_bar_chart, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskBasicDetails.taskPriority),
                            decoration: const InputDecoration(
                              label: Text('Priority', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.low_priority, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskCreationTime.toString().split(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('Create Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskStartTime.toString().splitMapJoin(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('Start Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskEndTime.toString().splitMapJoin(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('End Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskDueTime.toString().splitMapJoin(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('Due Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          task.taskSupervisor != null ? ExpansionTile(
                            onExpansionChanged: (value) {
                              setState(() {
                                isExpandTaskSupervisor = value;
                              });
                            },
                            leading: isExpandTaskSupervisor ? const Icon(Icons.close, color: Colors.redAccent) : Icon(Icons.remove_circle, color: Colors.blueAccent),
                            title: Text('Supervisors', style: TextStyle(color: Color.lerp(Colors.black, Colors.white, 0.5))),
                            children: [
                              ListView.builder(
                                itemCount: task.taskSupervisor!.length,
                                itemBuilder: (context, index) {
                                  Future<Supervisor?> supervisor = supervisorProvider.getSupervisor(task.taskSupervisor![index]);
                                  return FutureBuilder<Supervisor?>(
                                    future: supervisor,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        Supervisor? supervisor = snapshot.data;
                                        return TextFormField(
                                          controller: TextEditingController(text: supervisor!.supervisorName.supervisorFirstName),
                                          decoration: InputDecoration(
                                            icon: const Icon(Icons.person, color: Colors.blueAccent),
                                            label: Text('Supervisor ${index+1}', style: const TextStyle(color: Colors.blueAccent)),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ) : Container(),
                        ],
                      ),
                      actions: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          }, 
                          icon: const Icon(Icons.check, color: Colors.blueAccent,),
                          label: const Text('Ok', style: TextStyle(color: Colors.blueAccent)),
                        )
                      ],
                    );
                  }
                );
              },
              onUpdate: (Task task) {
                showDialog(
                  context: context,
                  builder: (context) {
                    String newTitle = task.taskTitle;
                    String? newDescription = task.taskBasicDetails.taskDescription;
                    String newPriority = task.taskBasicDetails.taskPriority;
                    DateTime newStartTime = task.taskTimingAndSchedule.taskStartTime;
                    DateTime? newEndTime = task.taskTimingAndSchedule.taskEndTime;
                    DateTime newDueTime = task.taskTimingAndSchedule.taskDueTime;
                    return AlertDialog(
                      title: const Text('Task Details', style: TextStyle(color: Colors.blueAccent)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            onChanged: (title) {
                              newTitle = title;
                            },
                            controller: TextEditingController(text: task.taskTitle),
                            decoration: const InputDecoration(
                              label: Text('Title', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.text_fields, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            onChanged: (description) {
                              newDescription = description;
                            },
                            controller: TextEditingController(text: task.taskBasicDetails.taskDescription),
                            decoration: const InputDecoration(
                              label: Text('Description', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.description, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskBasicDetails.taskStatus),
                            decoration: const InputDecoration(
                              label: Text('Status', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.stacked_bar_chart, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            onChanged: (priority) {
                              newPriority = priority;
                            },
                            controller: TextEditingController(text: task.taskBasicDetails.taskPriority),
                            decoration: const InputDecoration(
                              label: Text('Priority', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.low_priority, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskCreationTime.toString().split(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('Create Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            onChanged: (startTime) {
                              newStartTime = DateTime.parse(startTime);
                            },
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskStartTime.toString().splitMapJoin(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('Start Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            onChanged: (endTime) {
                              newEndTime = DateTime.parse(endTime);
                            },
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskEndTime.toString().splitMapJoin(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('End Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          TextFormField(
                            onChanged: (dueTime) {
                              newDueTime = DateTime.parse(dueTime);
                            },
                            controller: TextEditingController(text: task.taskTimingAndSchedule.taskDueTime.toString().splitMapJoin(' ')[0]),
                            decoration: const InputDecoration(
                              label: Text('Due Date', style: TextStyle(color: Colors.blueAccent)),
                              icon: Icon(Icons.date_range, color: Colors.blueAccent)
                            ),
                          ),
                          task.taskSupervisor != null ? ExpansionTile(
                            onExpansionChanged: (value) {
                              setState(() {
                                isExpandTaskSupervisor = value;
                              });
                            },
                            leading: isExpandTaskSupervisor ? const Icon(Icons.close, color: Colors.redAccent) : Icon(Icons.remove_circle, color: Colors.blueAccent),
                            title: Text('Supervisors', style: TextStyle(color: Color.lerp(Colors.black, Colors.white, 0.5))),
                            children: [
                              ListView.builder(
                                itemCount: task.taskSupervisor!.length,
                                itemBuilder: (context, index) {
                                  Future<Supervisor?> supervisor = supervisorProvider.getSupervisor(task.taskSupervisor![index]);
                                  return FutureBuilder<Supervisor?>(
                                    future: supervisor,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        Supervisor? supervisor = snapshot.data;
                                        return TextFormField(
                                          controller: TextEditingController(text: supervisor!.supervisorName.supervisorFirstName),
                                          decoration: InputDecoration(
                                            icon: const Icon(Icons.person, color: Colors.blueAccent),
                                            label: Text('Supervisor ${index+1}', style: const TextStyle(color: Colors.blueAccent)),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ) : Container(),
                        ],
                      ),
                      actions: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.cancel, color: Colors.redAccent,),
                          label: const Text('Cancel', style: TextStyle(color: Colors.redAccent),),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            updateTask(context, index, newTitle, newDescription, task.taskBasicDetails.taskStatus, newPriority, task.taskTimingAndSchedule.taskCreationTime, newStartTime, newEndTime, newDueTime);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.update, color: Colors.amber,),
                          label: const Text('Update', style: TextStyle(color: Colors.amber),),
                        ),
                      ],
                    );
                  },  
                );
              },
              onDelete: (Task task) {
                
              },
            );
          },
        ),
      );
    }
  }
}