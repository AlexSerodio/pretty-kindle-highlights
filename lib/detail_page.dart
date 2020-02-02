import 'package:flutter/material.dart';
import 'package:pretty_kindle_highlights/model/book.dart';

class DetailPage extends StatelessWidget {
  final Book book;
  
  DetailPage({Key key, this.book}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(book.title)
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
    );
  }
}