import 'package:flutter/material.dart';
import 'dart:io';
import '../models/task.dart';
import '../screens/add_edit_screen.dart';
import 'package:intl/intl.dart';

import '../screens/file_viewer_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const TaskCard({super.key, 
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _editTask(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildCompleteButton(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: task.dueDate != null
                        ? DateFormat('MMM d, y HH:mm').format(task.dueDate!)
                        : 'No due date',
                    color: Colors.blue,
                  ),
                  _buildInfoChip(
                    icon: Icons.flag,
                    label: task.priority,
                    color: _getPriorityColor(task.priority),
                  ),
                ],
              ),
              if (task.attachments.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildAttachmentsList(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return GestureDetector(
      onTap: onToggleComplete,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: task.isCompleted
              ? const Icon(Icons.check, size: 20, color: Colors.green)
              : const Icon(Icons.check, size: 20, color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAttachmentThumbnail(String attachmentPath) {
    final extension = attachmentPath.split('.').last.toLowerCase();
    IconData iconData;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        break;
      case 'txt':
        iconData = Icons.description;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.file(
            File(attachmentPath),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        );
      default:
        iconData = Icons.insert_drive_file;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(iconData, color: Colors.grey[600]),
    );
  }


  void _openAttachmentViewer(BuildContext context, String attachmentPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileViewerScreen(filePath: attachmentPath),
      ),
    );
  }

  Widget _buildAttachmentsList(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: task.attachments.length,
        itemBuilder: (context, index) {
          final attachment = task.attachments[index];
          return GestureDetector(
            onTap: () => _openAttachmentViewer(context, attachment),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildAttachmentThumbnail(attachment),
            ),
          );
        },
      ),
    );
  }

  void _editTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );
  }
}

