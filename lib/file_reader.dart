import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileReader {

  int _lineIndex = 0;
  List<String> _lines;

  Future<void> readFile() async {
    File file = await FilePicker.getFile();
    _lines = await file.readAsLines();
  }

  bool hasNextLine() {
    return _lineIndex < _lines.length;
  }

  void nextLine(){
    _lineIndex++;
  }

  String currentLine(){
    return _lines[_lineIndex];
  }

  String readLine(){
    return _lines[_lineIndex++];
  }

  void reset() {
    _lineIndex = 0;
    _lines = List<String>();
  }

}