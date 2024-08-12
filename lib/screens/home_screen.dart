import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/task_card.dart';
import '../services/database_service.dart';
import '../models/task.dart';

/// The main screen of the app, displaying a list of tasks and search functionality.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Loads tasks from the database and updates the state.
  void _loadTasks() async {
    final tasks = await _databaseService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(this),
              ).then((_) => _loadTasks()); // Reload tasks after search
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_task').then((_) => _loadTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            setState(() {
              _tasks.removeAt(index);
            });
            _databaseService.deleteTask(task.id).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      _databaseService.insertTask(task).then((_) => _loadTasks());
                    },
                  ),
                ),
              );
            });
          },
          child: TaskCard(
            task: task,
            onDelete: () async {
              await _databaseService.deleteTask(task.id);
              _loadTasks();
            },
            onToggleComplete: () async {
              task.isCompleted = !task.isCompleted;
              await _databaseService.updateTask(task);
              _loadTasks();
            },
          ),
        );
      },
    );
  }

  void updateTasksBasedOnSearch(String query) {
    if (query.isEmpty) {
      _loadTasks(); // Reset to all tasks if query is empty
    } else {
      setState(() {
        _tasks = _tasks.where((task) {
          final lowercaseQuery = query.toLowerCase();
          return task.title.toLowerCase().contains(lowercaseQuery) ||
              task.description.toLowerCase().contains(lowercaseQuery);
        }).toList();
      });
    }
  }
}


/// A search delegate for searching tasks.
class TaskSearchDelegate extends SearchDelegate<String> {
  final _HomeScreenState homeScreenState;

  TaskSearchDelegate(this.homeScreenState);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = homeScreenState._tasks.where((task) {
      final lowercaseQuery = query.toLowerCase();
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          task.description.toLowerCase().contains(lowercaseQuery);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].title),
          subtitle: Text(suggestions[index].description),
          onTap: () {
            query = suggestions[index].title;
            homeScreenState.updateTasksBasedOnSearch(query);
            close(context, query);
          },
        );
      },
    );
  }

  @override
  void close(BuildContext context, String result) {
    homeScreenState.updateTasksBasedOnSearch('');
    super.close(context, result);
  }
}