import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';

/// Screen for adding a new task or editing an existing one.
class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  late String _title;
  late String _description;
  String _category = 'Work';
  String _priority = 'Medium';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _category = widget.task!.category;
      _priority = widget.task!.priority;
    }
  }

  /// Saves the task to the database and closes the screen.
  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        category: _category,
        priority: _priority,
      );

      if (widget.task == null) {
        await _databaseService.insertTask(task);
      } else {
        await _databaseService.updateTask(task);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                initialValue: widget.task?.title ?? '',
                labelText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              _buildTextFormField(
                initialValue: widget.task?.description ?? '',
                labelText: 'Description',
                maxLines: 3,
                onSaved: (value) => _description = value!,
              ),
              _buildDropdownButtonFormField(
                value: _category,
                labelText: 'Category',
                items: ['Work', 'Personal', 'Shopping', 'Other'],
                onChanged: (value) => setState(() => _category = value!),
              ),
              _buildDropdownButtonFormField(
                value: _priority,
                labelText: 'Priority',
                items: ['Low', 'Medium', 'High'],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a TextFormField with common properties.
  Widget _buildTextFormField({
    required String initialValue,
    required String labelText,
    int? maxLines,
    String? Function(String?)? validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: labelText),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }

  /// Builds a DropdownButtonFormField with common properties.
  Widget _buildDropdownButtonFormField({
    required String value,
    required String labelText,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: labelText),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

