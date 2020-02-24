import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pretty_kindle_highlights/file_reader.dart';
import 'package:pretty_kindle_highlights/model/book.dart';
import 'package:pretty_kindle_highlights/detail_page.dart';
import 'package:pretty_kindle_highlights/mocks.dart';
import 'package:pretty_kindle_highlights/model/highlight.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pretty Kindle Highlights',
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: new ListPage(title: 'Books'),
    );
  }

}

class ListPage extends StatefulWidget {

  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage> {

  List books;
  FileReader fileReader;

  @override
  void initState() {
    books = Mocks.getBooks();
    fileReader = new FileReader();
    
    super.initState();
  }

  void syncHighlights() async {
    File file = await fileReader.getFile();

    List<String> lines = await file.readAsLines();

    Set<String> titles = new Set();
    Set<Book> books = new Set();
    Set<Highlight> highlights = new Set();

    String highlightDelimiter = '==========';
    int bookId = 0;
    int highlightId = 0;
    
    int index = 0;
    while (index < lines.length) {

      if(!titles.contains(lines[index])) {
        titles.add(lines[index]);

        String title = lines[index].substring(0, lines[index].lastIndexOf('(')-1);

        int start = lines[index].lastIndexOf('(')+1;
        int end = lines[index].lastIndexOf(')');
        String author = lines[index].substring(start, end);
        
        books.add(new Book(id: bookId++, title: title, author: author));
      }

      index++;
      
      String position = lines[index].split(' | ')[0];
      String date = lines[index].split(' | ')[1];

      index++;

      String text = '';
      while(lines[index] != highlightDelimiter) {
        text += lines[index];
        index++;
      }

      Highlight highlight = new Highlight(
        id: highlightId++, 
        text: text, 
        position: position, 
        date: date, 
        bookId: bookId
      );

      highlights.add(highlight);

      index++;
    }

    for (var book in books) {
      print(book);
    }

    print('--------------');

    for (var highlight in highlights) {
      print('$highlight\n');
    }

    print('File reader has finished');
    print("Books found: " + books.length.toString());
    print("Highlights found: " + highlights.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.sync),
          onPressed: () {
            syncHighlights();
          },
        )
      ],
    );

    ListTile makeListTile(Book book) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        book.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: 
        Text(book.author, style: TextStyle(color: Colors.white)),
      trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => DetailPage(book: book))
        );
      }
    );

    Card makeCard(Book book) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(book),
      ),
    );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(books[index]);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
    );
  }

}
