import 'package:flutter/material.dart';
import 'package:pretty_kindle_highlights/file_processor.dart';
import 'package:pretty_kindle_highlights/model/book.dart';
import 'package:pretty_kindle_highlights/detail_page.dart';

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

  @override
  void initState() {
    books = new List();
    super.initState();
  }

  void syncHighlights() async {
    FileProcessor processor = new FileProcessor();
    await processor.process();
    setState(() => books = processor.books);
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

    final noBody = Container(
      child: Center(
        child: Text(
          'No book found. Try to resync the app.', 
          style: TextStyle(color: Colors.white, fontSize: 16)
        ),
      )
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: books.isNotEmpty ? makeBody : noBody,
    );
  }

}
