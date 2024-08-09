/// Represents a task in the task management application.
class Task {
  final String id;
  String title;
  String description;
  String category;
  String priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });

  /// Converts the Task object to a Map for database operations.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  /// Creates a Task object from a Map, typically used when reading from the database.
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}



