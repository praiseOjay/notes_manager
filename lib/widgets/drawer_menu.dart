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
          _buildDrawerHeader(context),
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
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _navigateTo(context, '/settings'),
          ),
        ],
      ),
    );
  }

  /// Builds the drawer header with a gradient background and app logo.
  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Task Management App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Organize your tasks efficiently',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
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
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  /// Navigates to the specified route and closes the drawer.
  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushReplacementNamed(context, routeName);
  }
}
