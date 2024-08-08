import 'package:flutter/material.dart';
import 'package:notes_manager/screens/home_screen.dart';
import 'package:notes_manager/screens/settings_screen.dart';
import 'package:notes_manager/screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme_manager.dart';
import 'screens/add_edit_screen.dart'; // Import your AddTaskScreen

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
          home: SplashScreen(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => SplashScreen());
              case '/home':
                return MaterialPageRoute(builder: (_) => TaskListScreen());
              case '/task_list':
                return MaterialPageRoute(builder: (_) => TaskListScreen());
              case '/add_task':
                return MaterialPageRoute(builder: (_) => AddEditTaskScreen());
              case '/settings':
                return MaterialPageRoute(builder: (_) => SettingsScreen());
              default:
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
