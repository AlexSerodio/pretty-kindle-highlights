import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileReader {

  static Future<File> getFile() async {
    File file = await FilePicker.getFile();
    return file;
  }

}