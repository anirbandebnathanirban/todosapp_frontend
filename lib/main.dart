import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_branch/models/user/user.dart';
import './provider/auth_provider.dart';
import './provider/task_provider.dart';
import './provider/user_provider.dart';
import './provider/team_provider.dart';
import './provider/supervisor_provider.dart';
import './screens/todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        home: TodoListScreen(),
      ),
    );
  }
}

