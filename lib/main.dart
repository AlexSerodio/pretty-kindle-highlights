import 'package:flutter/material.dart';
import 'package:pretty_kindle_highlights/model/book.dart';
import 'package:pretty_kindle_highlights/detail_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
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
    books = getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
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
        itemCount: 10,
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

List getBooks() {
  return [
    Book(
        title: "1984 (Classics To Go)",
        author: "Orwell, George"
    ),
    Book(
        title: "DevOps na prática: entrega de software confiável e automatizada",
        author: "Danilo Sato"
    ),
    Book(
        title: "O voto feminino no Brasil",
        author: "Novaes Marques, Teresa Cristina"
    ),
    Book(
        title: "Astrofísica Para Apressados",
        author: "deGrasse Tyson, Neil"
    ),
    Book(
        title: "Alice's Adventures in Wonderland (AmazonClassics Edition)",
        author: "Carroll, Lewis"
    ),
    Book(
        title: "O que é o amor?",
        author: "Martins, Daniel"
    ),
    Book(
        title: "Entre a Esquerda e a Direita: Uma reflexão política",
        author: "Arrais, Rafael"
    ),

    Book(
        title: "Sapiens",
        author: "Harari, Yuval Noah"
    ),
    Book(
        title: "Design Patterns com Java: Projeto orientado a objetos guiado por padrões",
        author: "Eduardo Guerra"
    ),
    Book(
        title: "Arrume a sua cama",
        author: "Mcraven, William H."
    ),
    Book(
        title: "Lean Inception: Como Alinhar Pessoas e Construir o Produto Certo",
        author: "Caroli, Paulo"
    ),
    Book(
        title: "Clube da luta",
        author: "Palahniuk, Chuck"
    ),

    Book(
        title: "O melhor do Cortella: Trilhas do Pensar - Ideias, Frases e Inspirações",
        author: "Cortella, Mario Sergio"
    ),
    Book(
        title: "A História do Universo para quem tem pressa",
        author: "Stuart, Colin"
    ),
    Book(
        title: "Minimalismo 2.0: Como simplificar sua vida no século XXI (e diminuir seu impacto no meio ambiente)",
        author: "Müller, Izzy"
    ),
  ];
}