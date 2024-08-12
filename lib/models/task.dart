
/// Represents a task in the task management application.
class Task {
  final String id;
  String title;
  String description;
  String category;
  String priority;
  bool isCompleted;
  List<String> attachments; // New field for attachments
  DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    this.attachments = const [], // Initialize with an empty list
    this.dueDate,
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
      'attachments': attachments.join(','), // Store attachments as comma-separated string
      'dueDate': dueDate?.toIso8601String(), // Convert DateTime to string
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
      attachments: map['attachments']?.split(',') ?? [], // Convert string back to list
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null, // Parse string to DateTime
    );
  }
}



