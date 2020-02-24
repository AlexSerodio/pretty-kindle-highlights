import 'dart:io';

import 'package:pretty_kindle_highlights/file_reader.dart';

import 'model/book.dart';
import 'model/highlight.dart';

class FileProcessor {

  String _highlightDelimiter = '==========';
  String _positionAndDateDelimiter = ' | ';
  String _startAuthorDelimiter = '(';
  String _endAuthorDelimiter = ')';

  int _lineIndex = 0;
  List<String> _lines;

  Set<Book> _books = new Set();
  Set<Highlight> _highlights = new Set();
  Set<String> _titles = new Set();

  Set<Book> get books => _books;
  Set<Highlight> get highlights => _highlights;

  void _nextLine(){
    _lineIndex++;
  }

  String _currentLine(){
    return _lines[_lineIndex];
  }

  String _readLine(){
    return _lines[_lineIndex++];
  }

  bool _hasNextLine() {
    return _lineIndex < _lines.length;
  }

  void process() async {
    _reset();

    File file = await FileReader.getFile();
    _lines = await file.readAsLines();
    
    while (_hasNextLine()) {
      String line = _readLine();
      _processBook(line);

      line = _readLine();
      String position = _processPosition(line);
      String date = _processDate(line);

      _nextLine();
      _processHighlight(position, date);

      _nextLine();
    }

    _printResults();
  }

  void _reset() {
    _books = new Set();
    _highlights = new Set();
    _titles = new Set();
    _lineIndex = 0;
    _lines = List<String>();
  }

  void _processBook(String line) {
    if(!_titles.contains(line)) {
      _titles.add(line);

      String title = line.substring(0, line.lastIndexOf(_startAuthorDelimiter)-1);

      int start = line.lastIndexOf(_startAuthorDelimiter)+1;
      int end = line.lastIndexOf(_endAuthorDelimiter);
      String author = line.substring(start, end);
      
      _books.add(new Book(id: _books.length, title: title, author: author));
    }
  }

  String _processPosition(String line) {
    String fullPosition = line.split(_positionAndDateDelimiter)[0];
    int start = fullPosition.lastIndexOf(' ') + 1;

    return fullPosition.substring(start, fullPosition.length);
  }

  String _processDate(String line) {
    String fullDate = line.split(_positionAndDateDelimiter)[1];
    int start = fullDate.lastIndexOf(', ') + 2;

    return fullDate.substring(start, fullDate.length);
  }

  void _processHighlight(String position, String date) {
    String text = '';
    while(_currentLine() != _highlightDelimiter) {
      text += _readLine();
    }

    Highlight highlight = new Highlight(
      id: _highlights.length, 
      text: text, 
      position: position, 
      date: date, 
      bookId: _books.length
    );

    _highlights.add(highlight);
  }

  void _printResults() {

    for (var highlight in _highlights)
      print(highlight);

    print('=================================================');

    for (var book in _books)
      print(book);

    print('=================================================');

    print('File processing has finished successfully.');
    print("Books found: " + _books.length.toString());
    print("Highlights found: " + _highlights.length.toString());
  }

}