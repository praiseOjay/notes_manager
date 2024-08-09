import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_service.dart';
import '../models/task.dart';

/// Service for synchronizing tasks between the local database and a remote server.
class SyncService {
  final DatabaseService _databaseService = DatabaseService();
  final String _apiUrl = 'https://your-api-url.com/sync'; // Replace with your actual API URL

  /// Synchronizes tasks between the local database and the remote server.
  Future<void> syncData() async {
    try {
      // Get local tasks
      List<Task> localTasks = await _databaseService.getTasks();

      // Send local tasks to server
      final response = await _sendTasksToServer(localTasks);

      if (response.statusCode == 200) {
        // Parse server response
        List<dynamic> serverTasks = jsonDecode(response.body);

        // Update local database with server data
        await _updateLocalDatabase(serverTasks);
      } else {
        throw Exception('Failed to sync data');
      }
    } catch (e) {
      print('Error syncing data: $e');
      rethrow;
    }
  }

  /// Sends local tasks to the server.
  Future<http.Response> _sendTasksToServer(List<Task> localTasks) async {
    return await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(localTasks.map((task) => task.toMap()).toList()),
    );
  }

  /// Updates the local database with tasks received from the server.
  Future<void> _updateLocalDatabase(List<dynamic> serverTasks) async {
    for (var taskMap in serverTasks) {
      Task task = Task.fromMap(taskMap);
      await _databaseService.insertTask(task);
    }
  }
}
