import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class FileViewerScreen extends StatelessWidget {
  final String filePath;

  const FileViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final String extension = filePath.split('.').last.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Viewer'),
      ),
      body: _buildFileViewer(context, extension),
    );
  }

  Widget _buildFileViewer(BuildContext context, String extension) {
    switch (extension) {
      case 'pdf':
        return PDFView(
          filePath: filePath,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
        );
      case 'txt':
        return FutureBuilder<String>(
          future: File(filePath).readAsString(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(snapshot.data ?? ''),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      default:
        return Center(
          child: ElevatedButton(
            child: const Text('Open File'),
            onPressed: () => _openFile(context),
          ),
        );
    }
  }

  void _openFile(BuildContext context) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: ${result.message}')),
      );
    }
  }
}
