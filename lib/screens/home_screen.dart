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
  String _searchQuery = '';

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

  /// Returns a filtered list of tasks based on the current search query.
  List<Task> get _filteredTasks {
    if (_searchQuery.isEmpty) {
      return _tasks;
    }
    return _tasks.where((task) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          task.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: hintColor),
          ),
          style: TextStyle(color: textColor),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear, color: textColor),
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
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

  /// Builds the list of tasks with pull-to-refresh and dismissible functionality
  Widget _buildTaskList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadTasks();
      },
      child: ListView.builder(
        itemCount: _filteredTasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_filteredTasks[index].id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) async {
              await _databaseService.deleteTask(_filteredTasks[index].id);
              setState(() {
                _tasks.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            child: TaskCard(
              task: _filteredTasks[index],
              onDelete: () async {
                await _databaseService.deleteTask(_filteredTasks[index].id);
                _loadTasks();
              },
              onToggleComplete: () async {
                _filteredTasks[index].isCompleted = !_filteredTasks[index].isCompleted;
                await _databaseService.updateTask(_filteredTasks[index]);
                _loadTasks();
              },
            ),
          );
        },
      ),
    );
  }
}
