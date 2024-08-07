import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class SyncService {
  final String _baseUrl = 'https://your-api-endpoint.com'; // Replace with your actual API endpoint

  Future<void> syncTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to sync task');
      }
    } catch (e) {
      print('Error syncing task: $e');
      // TODO: Implement proper error handling and retry mechanism
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/tasks/$taskId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print('Error deleting task: $e');
      // TODO: Implement proper error handling and retry mechanism
    }
  }

  Future<void> syncAllTasks(List<Task> tasks) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tasks/sync'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tasks.map((task) => task.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> syncedTasks = json.decode(response.body);
        // TODO: Update local tasks with synced data
      } else {
        throw Exception('Failed to sync tasks');
      }
    } catch (e) {
      print('Error syncing all tasks: $e');
      // TODO: Implement proper error handling and retry mechanism
    }
  }
}
