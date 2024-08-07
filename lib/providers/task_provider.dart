import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final Box<Task> _taskBox = Hive.box<Task>('tasks');
  final NotificationService _notificationService = NotificationService();
  final SyncService _syncService = SyncService();

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
    _loadTasks();
    _scheduleNotification(task);
    _syncService.syncTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
    _loadTasks();
    _scheduleNotification(task);
    _syncService.syncTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    _loadTasks();
    await _notificationService.cancelNotification(int.parse(id));
    _syncService.deleteTask(id);
  }

  void _scheduleNotification(Task task) {
    if (!task.isCompleted) {
      _notificationService.scheduleNotification(
        id: int.parse(task.id),
        title: 'Task Reminder',
        body: task.title,
        scheduledDate: task.dueDate,
      );
    }
  }

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> getTasksByPriority(int priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  Future<void> syncTasks() async {
    await _syncService.syncAllTasks(_tasks);
    _loadTasks();
  }
}
