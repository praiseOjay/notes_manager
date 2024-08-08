import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';
import '../services/sync_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final syncService = SyncService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: themeManager.isDarkMode,
              onChanged: (value) {
                themeManager.toggleTheme();
              },
            ),
          ),
                   ListTile(
            title: Text('Theme Color'),
            trailing: DropdownButton<MaterialColor>(
              value: themeManager.primaryColor,
              onChanged: (MaterialColor? newColor) {
                if (newColor != null) {
                  themeManager.changePrimaryColor(newColor);
                }
              },
              items: [
                DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
                DropdownMenuItem(value: Colors.green, child: Text('Green')),
                DropdownMenuItem(value: Colors.red, child: Text('Red')),
                DropdownMenuItem(value: Colors.purple, child: Text('Purple')),
              ],
            ),
          ),
          ListTile(
            title: Text('Sync Data'),
            trailing: ElevatedButton(
              onPressed: () async {
                try {
                  await syncService.syncData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data synced successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error syncing data: $e')),
                  );
                }
              },
              child: Text('Sync Now'),
            ),
          ),
        ],
      ),
    );
  }
}

