import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/loading.dart';
import '../models/task/task.dart';
import '../provider/auth_provider.dart';
import '../provider/task_provider.dart';
import '../provider/supervisor_provider.dart';
import '../provider/team_provider.dart';
import '../provider/user_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<Task> onChanged;
  final Function(Task) details;
  final ValueChanged<Task> onUpdate;
  final ValueChanged<Task> onDelete;

  TaskItem({
    required this.task,
    required this.onChanged,
    required this.details,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context);
    final supervisorProvider =
        Provider.of<SupervisorProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return taskProvider.isLoading
        ? Loading()
        : Card(
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
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: IconButton(
                  icon: task.taskBasicDetails.taskStatus == 'Pending'
                      ? Icon(
                          Icons.radio_button_unchecked,
                          color: Color.lerp(Colors.black, Colors.white, 0.5),
                        )
                      : task.taskBasicDetails.taskStatus == 'In Progress'
                          ? const Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.blueAccent,
                            )
                          : task.taskBasicDetails.taskStatus == 'Completed'
                              ? const Icon(
                                  Icons.task_alt,
                                  color: Colors.greenAccent,
                                )
                              : const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                  onPressed: () => onChanged(task),
                ),
                title: Text(
                  task.taskTitle,
                  style: TextStyle(
                      fontSize: 20,
                      decoration:
                          task.taskBasicDetails.taskStatus == 'Completed'
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      color: Color.lerp(Colors.black, Colors.white, 0.6)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskBasicDetails.taskDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.lightBlue,
                        decoration:
                            task.taskBasicDetails.taskStatus == 'Completed'
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'priority: ${task.taskBasicDetails.taskPriority}',
                      style: TextStyle(
                        fontSize: 12,
                        color: task.taskBasicDetails.taskPriority == 'Low'
                            ? Colors.lightGreen
                            : task.taskBasicDetails.taskPriority == 'Moderate'
                                ? Colors.orangeAccent
                                : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'start: ${task.taskTimingAndSchedule.taskStartTime.toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Due: ${task.taskTimingAndSchedule.taskDueTime.toString().split(' ')[0]}',
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
                          onPressed: () => details(task),
                          icon: const Icon(Icons.details,
                              color: Colors.blueAccent),
                          label: const Text('Details',
                              style: TextStyle(color: Colors.blueAccent))),
                      TextButton.icon(
                        onPressed: () => onUpdate(task),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        label: const Text('Update',
                            style: TextStyle(color: Colors.blue)),
                      ),
                      TextButton.icon(
                        onPressed: () => onDelete(task),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
