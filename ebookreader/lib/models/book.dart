import 'dart:convert';
import 'package:http/http.dart' as http;

class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      downloadUrl: json['download_url'] ?? '',
    );
  }
}

Future<List<Book>> fetchBooks() async {
  final response = await http.get(Uri.parse('https://escribo.com/books.json'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => Book.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}
