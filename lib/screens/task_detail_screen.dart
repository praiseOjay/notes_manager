import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? task;

  const TaskDetailScreen({super.key, this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late String _category;
  late int _priority;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _category = widget.task?.category ?? '';
    _priority = widget.task?.priority ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            ListTile(
              title: Text('Due Date'),
              subtitle: Text(_dueDate.toString()),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _dueDate) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
            ),
            TextFormField(
              initialValue: _category,
              decoration: InputDecoration(labelText: 'Category'),
              onSaved: (value) => _category = value!,
            ),
            DropdownButtonFormField<int>(
              value: _priority,
              decoration: InputDecoration(labelText: 'Priority'),
              items: [0, 1, 2, 3].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (widget.task == null) {
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _title,
          description: _description,
          dueDate: _dueDate,
          category: _category,
          priority: _priority,
        );
        taskProvider.addTask(newTask);
      } else {
        final updatedTask = Task(
          id: widget.task!.id,
          title: _title,
          description: _description,
          dueDate: _dueDate,
          isCompleted: widget.task!.isCompleted,
          category: _category,
          priority: _priority,
        );
        taskProvider.updateTask(updatedTask);
      }
      Navigator.pop(context);
    }
  }
}
