import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/task_card.dart';
import '../services/database_service.dart';
import '../models/task.dart';

/// A screen that displays a list of tasks with filtering options.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Service to interact with the database
  final DatabaseService _databaseService = DatabaseService();
  // List to store all tasks
  List<Task> _tasks = [];
  // Selected category and priority for filtering
  String _selectedCategory = 'All';
  String _selectedPriority = 'All';

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

  /// Returns a filtered list of tasks based on selected category and priority.
  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      bool categoryMatch = _selectedCategory == 'All' || task.category == _selectedCategory;
      bool priorityMatch = _selectedPriority == 'All' || task.priority == _selectedPriority;
      return categoryMatch && priorityMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          _buildFilterOptions(),
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  /// Builds the filter options for category and priority.
  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              value: _selectedCategory,
              items: ['All', 'Work', 'Personal', 'Shopping', 'Other'],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown(
              value: _selectedPriority,
              items: ['All', 'Low', 'Medium', 'High'],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a dropdown button with the given parameters.
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  /// Builds the list of filtered tasks.
  Widget _buildTaskList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadTasks();
      },
      child: ListView.builder(
        itemCount: _filteredTasks.length,
        itemBuilder: (context, index) {
          final task = _filteredTasks[index];
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
              // Remove task from lists and database
              setState(() {
                _filteredTasks.removeAt(index);
                _tasks.remove(task);
              });
              _databaseService.deleteTask(task.id).then((_) {
                // Show snackbar with undo option
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
      ),
    );
  }
}
