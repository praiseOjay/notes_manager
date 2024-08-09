import 'package:flutter/material.dart';
import 'package:notes_manager/screens/add_edit_screen.dart';
import 'package:notes_manager/screens/home_screen.dart';
import 'package:notes_manager/screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/theme_manager.dart';

/// The main entry point of the application.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          title: 'Task Management App',
          theme: themeManager.themeData,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
            '/task_list': (context) => const TaskListScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/add_task': (context) => const AddEditTaskScreen()
          },
        );
      },
    );
  }
}



