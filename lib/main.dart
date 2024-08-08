import 'package:flutter/material.dart';
import 'package:notes_manager/screens/add_edit_screen.dart';
import 'package:notes_manager/screens/home_screen.dart';
import 'package:notes_manager/screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_screen.dart'; // Import your SettingsScreen
import 'utils/theme_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          title: 'Task Management App',
          theme: themeManager.themeData,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/home': (context) => HomeScreen(),
            '/task_list': (context) => TaskListScreen(),
            '/settings': (context) => SettingsScreen(),
            '/add_task': (context) => AddEditTaskScreen()

          },
        );
      },
    );
  }
}
