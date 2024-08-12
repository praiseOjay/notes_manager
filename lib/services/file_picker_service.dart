import 'package:file_picker/file_picker.dart';

/// Service for picking files from the device.
class FilePickerService {
  /// Allows the user to pick multiple files.
  /// Returns a list of file paths.
  Future<List<String>> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      return result.paths.whereType<String>().toList();
    } else {
      return [];
    }
  }
}
