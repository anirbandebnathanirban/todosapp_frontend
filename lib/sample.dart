import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.purpleAccent),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Color.lerp(Colors.black, Colors.white, 0.5),
            fontSize: 24,
          )
        ),
        scaffoldBackgroundColor: Colors.white
      ),
      home: TodoListScreen()
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isExpand = false;
  final List<Task> tasks = [
    Task(title: 'Task 1', description: 'Description for Task 1', dueDate: DateTime.now()),
    Task(title: 'Task 2', description: 'Description for Task 2', dueDate: DateTime.now().add(Duration(days: 1))),
  ];

  void updateTask(Task task, String newTitle, String newDescription) {
    setState(() {
      task.title = newTitle;
      task.description = newDescription;
    });
  }

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  isExpand = value;
                });
              },
              leading: Icon(Icons.menu, color: isExpand ? Colors.greenAccent : Colors.blueAccent),
              title: Text('Menu', style: TextStyle(color: Color.lerp(Colors.black, Colors.white, 0.5))),
              children: [
                ListTile(
                  leading: const Icon(Icons.align_vertical_bottom, color: Colors.purpleAccent),
                  title: const Text('Menu Item 1', style: TextStyle(color: Colors.lightBlue)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.align_vertical_bottom, color: Colors.purpleAccent),
                  title: const Text('Menu Item 2', style: TextStyle(color: Colors.lightBlue)),
                  onTap: () {},
                ),
              ],
            ),
            ExpansionTile(
              onExpansionChanged: (value) {
                setState(() {
                  isExpand = value;
                });
              },
              leading: Icon(Icons.settings, color: isExpand ? Colors.greenAccent : Colors.blueAccent),
              title: Text('Settings', style: TextStyle(color: Color.lerp(Colors.black, Colors.white, 0.5)),),
              children: [
                ListTile(
                  leading: const Icon(Icons.bubble_chart, color: Colors.purpleAccent),
                  title: const Text('Setting 1', style: TextStyle(color: Colors.lightBlue)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bubble_chart, color: Colors.purpleAccent),
                  title: const Text('Setting 2', style: TextStyle(color: Colors.lightBlue),),
                  onTap: () {},
                ),
              ],
            ),
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
            onChanged: (value) {
              setState(() {
                tasks[index].isCompleted = value!;
              });
            },
            onUpdate: (Task task) {
              showDialog(
                context: context,
                builder: (context) {
                  String newTitle = task.title;
                  String newDescription = task.description;
                  return AlertDialog(
                    title: const Text('Update Task', style: TextStyle(color: Colors.blueAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            newTitle = value;
                          },
                          controller: TextEditingController(text: task.title),
                          decoration: const InputDecoration(
                            label: Text('Title', style: TextStyle(color: Colors.blueAccent)),
                            icon: Icon(Icons.text_fields, color: Colors.blueAccent)
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            newDescription = value;
                          },
                          controller: TextEditingController(text: task.description),
                          decoration: const InputDecoration(
                            label: Text('Description', style: TextStyle(color: Colors.blueAccent)),
                            icon: Icon(Icons.description, color: Colors.blueAccent)
                          ),
                        ),
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
                          updateTask(task, newTitle, newDescription);
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
              deleteTask(task);
            },
          );
        },
      ),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final ValueChanged<Task> onUpdate;
  final ValueChanged<Task> onDelete;

  TaskItem({
    required this.task,
    required this.onChanged,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          collapsedIconColor: Colors.blue,
          iconColor: Colors.greenAccent[700],
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: IconButton(
            icon: Icon(
              task.isCompleted ? Icons.task_alt : Icons.radio_button_unchecked,
              color: Colors.greenAccent[700],
            ),
            onPressed: () => onChanged(!task.isCompleted),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
              decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              color: Color.lerp(Colors.black, Colors.white, 0.6)
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.lightBlue,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Due: ${task.dueDate.toLocal()}'.split(' ')[0],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {}, 
                  icon: const Icon(Icons.details, color: Colors.blueAccent),
                  label: const Text('Details', style: TextStyle(color: Colors.blueAccent))
                ),
                TextButton.icon(
                  onPressed: () => onUpdate(task),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text('Update', style: TextStyle(color: Colors.blue)),
                ),
                TextButton.icon(
                  onPressed: () => onDelete(task),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}