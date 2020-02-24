import 'package:pretty_kindle_highlights/file_reader.dart';

import 'model/book.dart';
import 'model/highlight.dart';

class FileProcessor {

  String _highlightDelimiter = '==========';
  String _positionAndDateDelimiter = ' | ';
  String _startAuthorDelimiter = '(';
  String _endAuthorDelimiter = ')';

  FileReader _reader = new FileReader();

  Set<Book> _books = new Set();
  Set<Highlight> _highlights = new Set();
  Set<String> _titles = new Set();

  List<Book> get books => _books.toList();
  List<Highlight> get highlights => _highlights.toList();

  Future<void> process() async {
    _reset();

    try {
      await _reader.readFile();
    } catch(ex) {
      print(ex.toString());
      return;
    }
    
    while (_reader.hasNextLine()) {
      String line = _reader.readLine();
      _processBook(line);

      line = _reader.readLine();
      String position = _processPosition(line);
      String date = _processDate(line);

      _reader.nextLine();
      _processHighlight(position, date);

      _reader.nextLine();
    }
  }

  void _reset() {
    _books = new Set();
    _highlights = new Set();
    _titles = new Set();
    _reader.reset();
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
    while(_reader.currentLine() != _highlightDelimiter) {
      text += _reader.readLine();
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

}