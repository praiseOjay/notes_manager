import 'package:flutter/material.dart';
import 'package:notes_manager/services/database_service.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';

/// Screen for managing app settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Database service for task-related operations
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // Access the ThemeManager through Provider
    final themeManager = Provider.of<ThemeManager>(context);

    return PopScope(
      // Prevent default back navigation
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _navigateBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _navigateBack(context),
          ),
        ),
        body: ListView(
          children: [
            _buildSectionHeader('Appearance'),
            _buildSwitchTile(
              title: 'Dark Mode',
              value: themeManager.isDarkMode,
              onChanged: (value) {
                themeManager.toggleTheme();
              },
            ),
            _buildActionTile(
              title: 'Clear All Tasks',
              icon: Icons.delete_forever,
              onTap: () => _showClearTasksDialog(),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom back navigation to handle cases where the screen can't be popped
  void _navigateBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// Builds a header for a settings section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  /// Builds a switch tile for toggling settings
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  /// Builds an action tile for settings that perform an action when tapped
  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Colors.blue),
      onTap: onTap,
    );
  }

  /// Shows a confirmation dialog for clearing all tasks
  void _showClearTasksDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Tasks'),
          content: const Text('Are you sure you want to delete all tasks? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () async {
                // Delete all tasks from the database
                await _databaseService.deleteAllTasks();
                Navigator.of(context).pop();
                // Show a confirmation snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All tasks have been deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
