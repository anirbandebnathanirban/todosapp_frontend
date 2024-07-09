import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/auth_provider.dart';
import './provider/task_provider.dart';
import './provider/user_provider.dart';
import './provider/team_provider.dart';
import './provider/supervisor_provider.dart';
import './provider/screen_provider.dart';
import './screens/todo_list_screen.dart';
import './screens/signin_screen.dart';
import './screens/signup_screen.dart';
import './screens/add_task_screen_self.dart';
import './screens/add_task_screen_team.dart';
import './screens/add_supervisor_screen.dart';
import './screens/add_team_screen.dart';
// import './screens/team_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => SupervisorProvider()),
      ],
      child: MaterialApp(
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
        initialRoute: '/',
        routes: {
          '/': (context) => TodoListScreen(),
          '/signin': (context) => SigninScreen(),
          '/signup': (context) => SignupScreen(),
          '/addtaskself': (context) => AddTaskScreenSelf(),
          '/addtaskteam': (context) => AddTaskScreenTeam(),
          '/addsupervisor': (context) => AddSupervisorScreen(),
          '/addteam': (context) => AddTeamScreen(),
        },
      ),
    );
  }
}
