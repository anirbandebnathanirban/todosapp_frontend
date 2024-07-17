import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/loading.dart';
import './todo_list_screen.dart';
import './signin_screen.dart';
import './signup_screen.dart';
import '../provider/auth_provider.dart';
import '../provider/task_provider.dart';
import '../provider/supervisor_provider.dart';
import '../provider/team_provider.dart';
import '../provider/user_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final supervisorProvider = Provider.of<SupervisorProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (authProvider.isLoading) {
      return Loading();
    } else if (!authProvider.isSignedUp) {
      return SignupScreen();
    } else if (!authProvider.isSignedIn) {
      return SigninScreen();
    } else {
      return FutureBuilder<void>(
        future: _initializeData(authProvider, taskProvider, teamProvider, supervisorProvider, userProvider),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return TodoListScreen();
          }
        },
      );
    }
  }

  Future<void> _initializeData(AuthProvider authProvider, TaskProvider taskProvider, TeamProvider teamProvider, SupervisorProvider supervisorProvider, UserProvider userProvider) async {
    await taskProvider.getTasks(authProvider.user!.userTasks!);
    await teamProvider.getTeams(authProvider.user!.userTeams!);
    await supervisorProvider.getSupervisors();
    await userProvider.getAllRegisteredUser();
  }
}
