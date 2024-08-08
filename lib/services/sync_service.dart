import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_service.dart';
import '../models/task.dart';

class SyncService {
  final DatabaseService _databaseService = DatabaseService();
  final String _apiUrl = 'https://your-api-url.com/sync'; // Replace with your actual API URL

  Future<void> syncData() async {
    try {
      // Get local tasks
      List<Task> localTasks = await _databaseService.getTasks();

      // Send local tasks to server
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(localTasks.map((task) => task.toMap()).toList()),
      );

      if (response.statusCode == 200) {
        // Parse server response
        List<dynamic> serverTasks = jsonDecode(response.body);

        // Update local database with server data
        for (var taskMap in serverTasks) {
          Task task = Task.fromMap(taskMap);
          await _databaseService.insertTask(task);
        }
      } else {
        throw Exception('Failed to sync data');
      }
    } catch (e) {
      print('Error syncing data: $e');
      throw e;
    }
  }
}

  final DatabaseService _databaseService = DatabaseService();
  final String _apiUrl = 'https://your-api-url.com/sync'; // Replace with your actual API URL

  Future<void> syncData() async {
    try {
      // Get local tasks
      List<Task> localTasks = await _databaseService.getTasks();

      // Send local tasks to server
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(localTasks.map((task) => task.toMap()).toList()),
      );

      if (response.statusCode == 200) {
        // Parse server response
        List<dynamic> serverTasks = jsonDecode(response.body);

        // Update local database with server data
        for (var taskMap in serverTasks) {
          Task task = Task.fromMap(taskMap);
          await _databaseService.insertTask(task);
        }
      } else {
        throw Exception('Failed to sync data');
      }
    } catch (e) {
      print('Error syncing data: $e');
      throw e;
    }
  }
