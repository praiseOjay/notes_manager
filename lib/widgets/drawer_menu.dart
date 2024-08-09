import 'package:flutter/material.dart';

/// A drawer menu widget providing navigation options for the app.
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Task Management App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => _navigateTo(context, '/home'),
          ),
          _buildDrawerItem(
            icon: Icons.list,
            title: 'Task List',
            onTap: () => _navigateTo(context, '/task_list'),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _navigateTo(context, '/settings'),
          ),
        ],
      ),
    );
  }

  /// Builds a drawer item with an icon, title, and onTap function.
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  /// Navigates to the specified route and closes the drawer.
  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushReplacementNamed(context, routeName);
  }
}
