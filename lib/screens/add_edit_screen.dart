import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  // ignore: prefer_const_constructors_in_immutables
  AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _category = 'Work'; // Default category
  String _priority = 'Medium';
  List<String> _attachments = [];
  DateTime? _dueDate;
  final DatabaseService _databaseService = DatabaseService();

  // List of predefined categories
  final List<String> _categories = ['Work', 'Personal', 'Shopping', 'Other'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _category = widget.task?.category ?? 'Work';
    _priority = widget.task?.priority ?? 'Medium';
    _attachments = List.from(widget.task?.attachments ?? []);
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: textColor),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _titleController,
                  label: 'Title',
                  icon: Icons.title,
                  textColor: textColor,
                  backgroundColor: backgroundColor,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  maxLines: 3,
                  textColor: textColor,
                  backgroundColor: backgroundColor,
                ),
                const SizedBox(height: 16),
                _buildCategoryDropdown(textColor, backgroundColor),
                const SizedBox(height: 16),
                _buildPriorityDropdown(textColor, backgroundColor),
                const SizedBox(height: 16),
                _buildDueDatePicker(textColor, backgroundColor),
                const SizedBox(height: 16),
                _buildAttachmentSection(textColor, backgroundColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required Color textColor,
    required Color? backgroundColor,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        filled: true,
        fillColor: backgroundColor,
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown(Color textColor, Color? backgroundColor) {
    return DropdownButtonFormField<String>(
      value: _category,
      style: TextStyle(color: textColor),
      dropdownColor: backgroundColor,
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(Icons.category, color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        filled: true,
        fillColor: backgroundColor,
      ),
      items: _categories.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (value) => setState(() => _category = value!),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildPriorityDropdown(Color textColor, Color? backgroundColor) {
    return DropdownButtonFormField<String>(
      value: _priority,
      style: TextStyle(color: textColor),
      dropdownColor: backgroundColor,
      decoration: InputDecoration(
        labelText: 'Priority',
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(Icons.flag, color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        filled: true,
        fillColor: backgroundColor,
      ),
      items: ['Low', 'Medium', 'High'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (value) => setState(() => _priority = value!),
    );
  }

  Widget _buildDueDatePicker(Color textColor, Color? backgroundColor) {
    return InkWell(
      onTap: _pickDateTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Due Date',
          labelStyle: TextStyle(color: textColor),
          prefixIcon: Icon(Icons.calendar_today, color: textColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: textColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: textColor.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: textColor),
          ),
          filled: true,
          fillColor: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dueDate != null
                  ? DateFormat('MMM d, y HH:mm').format(_dueDate!)
                  : 'Not set',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            Icon(Icons.arrow_drop_down, color: textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentSection(Color textColor, Color? backgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attachments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        if (_attachments.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _attachments.map((path) => _buildAttachmentChip(path, textColor)).toList(),
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: Icon(Icons.attach_file, color: backgroundColor),
          label: Text('Add Attachment', style: TextStyle(color: backgroundColor)),
          style: ElevatedButton.styleFrom(
            backgroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentChip(String path, Color textColor) {
    return Chip(
      label: Text(
        path.split('/').last,
        style: TextStyle(fontSize: 12, color: textColor),
      ),
      onDeleted: () => setState(() => _attachments.remove(path)),
      deleteIcon: Icon(Icons.close, size: 16, color: textColor),
      backgroundColor: textColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: textColor.withOpacity(0.5)),
      ),
    );
  }


  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _attachments.add(result.files.single.path!);
      });
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

 void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        category: _category,
        priority: _priority,
        attachments: _attachments,
        dueDate: _dueDate,
        isCompleted: widget.task?.isCompleted ?? false,
      );
      if (widget.task == null) {
        _databaseService.insertTask(task);
      } else {
        _databaseService.updateTask(task);
      }
      Navigator.pop(context);
    }
  }
}
