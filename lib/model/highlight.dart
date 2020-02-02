import 'dart:convert';

Highlight highlightFromJson(String str) => Highlight.fromJson(json.decode(str));

String highlightToJson(Highlight data) => json.encode(data.toJson());

class Highlight {
  int id;
  String text;
  String position;
  String date;
  int bookId;

  Highlight({this.id, this.text, this.position, this.date, this.bookId});

  factory Highlight.fromJson(Map<String, dynamic> json) => Highlight(
      id: json["id"],
      text: json["text"],
      position: json["position"],
      date: json["date"],
      bookId: json["bookId"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "text": text,
      "position": position,
      "date": date,
      "bookId": bookId,
  };
}
