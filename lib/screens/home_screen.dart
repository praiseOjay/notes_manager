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
    return _tasks.where((task) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          task.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
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
              );
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: ListView.builder(
        itemCount: _filteredTasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: _filteredTasks[index],
            onDelete: () async {
              await _databaseService.deleteTask(_filteredTasks[index].id);
              _loadTasks();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_task').then((_) => _loadTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
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
    homeScreenState.setState(() {
      homeScreenState._searchQuery = query;
    });
    return Container();
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
            homeScreenState.setState(() {
              homeScreenState._searchQuery = query;
            });
            close(context, '');
          },
        );
      },
    );
  }
}
