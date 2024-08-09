import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';

/// A custom AppBar widget that adapts to the current theme and provides navigation functionality.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;

  const CustomAppBar({super.key, required this.title, required this.context});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeManager to get current theme data
    final themeManager = Provider.of<ThemeManager>(context);
    
    return AppBar(
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Use the current theme's primary color with opacity
          color: themeManager.themeData.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title),
      ),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          // Show menu icon on home screen, back arrow on other screens
          icon: Icon(title == 'Home' ? Icons.menu : Icons.arrow_back),
          onPressed: () {
            if (title == 'Home') {
              // Open the drawer on the home screen
              Scaffold.of(context).openDrawer();
            } else {
              // Navigate back to home on other screens
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

