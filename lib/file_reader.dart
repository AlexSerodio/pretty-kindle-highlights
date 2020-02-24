import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileReader {

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/kindle_highlights.txt');
  }

  Future<File> getFile() async {
    File file = await FilePicker.getFile();
    return file;
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      
      print(contents);
      return contents;
    } catch (e) {
      print(e);
      return "";
    }
  }


}