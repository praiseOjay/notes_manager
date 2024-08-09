import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';
import '../services/sync_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/drawer_menu.dart';

/// A screen for managing app settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final syncService = SyncService();

    return Scaffold(
      appBar: CustomAppBar(title: 'Settings', context: context),
      drawer: const DrawerMenu(),
      body: ListView(
        children: [
          _buildDarkModeSwitch(themeManager),
          _buildThemeColorDropdown(themeManager),
          _buildSyncDataButton(context, syncService),
        ],
      ),
    );
  }

  /// Builds a switch for toggling dark mode.
  Widget _buildDarkModeSwitch(ThemeManager themeManager) {
    return ListTile(
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: themeManager.isDarkMode,
        onChanged: (value) => themeManager.toggleTheme(),
      ),
    );
  }

  /// Builds a dropdown for selecting the theme color.
  Widget _buildThemeColorDropdown(ThemeManager themeManager) {
    return ListTile(
      title: const Text('Theme Color'),
      trailing: DropdownButton<MaterialColor>(
        value: themeManager.primaryColor,
        onChanged: (MaterialColor? newColor) {
          if (newColor != null) {
            themeManager.changePrimaryColor(newColor);
          }
        },
        items: const [
          DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
          DropdownMenuItem(value: Colors.green, child: Text('Green')),
          DropdownMenuItem(value: Colors.red, child: Text('Red')),
          DropdownMenuItem(value: Colors.purple, child: Text('Purple')),
        ],
      ),
    );
  }

  /// Builds a button for syncing data.
  Widget _buildSyncDataButton(BuildContext context, SyncService syncService) {
    return ListTile(
      title: const Text('Sync Data'),
      trailing: ElevatedButton(
        onPressed: () => _syncData(context, syncService),
        child: const Text('Sync Now'),
      ),
    );
  }

  /// Attempts to sync data and shows a snackbar with the result.
  void _syncData(BuildContext context, SyncService syncService) async {
    try {
      await syncService.syncData();
      _showSnackBar(context, 'Data synced successfully');
    } catch (e) {
      _showSnackBar(context, 'Error syncing data: $e');
    }
  }

  /// Shows a snackbar with the given message.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

