import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/add_edit_screen.dart';

/// A widget that displays a single task as a card.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(task.priority),
            const SizedBox(width: 8),
            _buildEditButton(context),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the edit button for the task card.
  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditTaskScreen(task: task),
          ),
        );
      },
    );
  }

  /// Builds the delete button for the task card.
  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onDelete,
    );
  }
}
