import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// A screen for viewing task attachments in detail.
class AttachmentViewerScreen extends StatefulWidget {
  final List<String> attachments;
  final int initialIndex;

  const AttachmentViewerScreen({
    super.key, 
    required this.attachments,
    required this.initialIndex,
  });

  @override
  _AttachmentViewerScreenState createState() => _AttachmentViewerScreenState();
}

class _AttachmentViewerScreenState extends State<AttachmentViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attachment ${_currentIndex + 1} of ${widget.attachments.length}'),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: _buildItem,
        itemCount: widget.attachments.length,
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(),
        ),
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  /// Builds individual items in the gallery
  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final attachment = widget.attachments[index];
    final file = File(attachment);
    
    if (_isImageFile(attachment)) {
      // Display image files using PhotoView
      return PhotoViewGalleryPageOptions(
        imageProvider: FileImage(file),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
      );
    } else {
      // Display non-image files with a generic icon and file name
      return PhotoViewGalleryPageOptions.customChild(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.insert_drive_file, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                file.path.split('/').last,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _openFile(file),
                child: const Text('Open File'),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Checks if the file is an image based on its extension
  bool _isImageFile(String filePath) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    return imageExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
  }

  /// Opens the file using the appropriate application
  void _openFile(File file) {
    // Implement file opening logic here
    // You may want to use a plugin like open_file or url_launcher
    if (kDebugMode) {
      print('Opening file: ${file.path}');
    }
  }
}
