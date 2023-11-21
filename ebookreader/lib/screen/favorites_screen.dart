import 'package:flutter/material.dart';
import 'package:ebookreader/widget/appbar.dart';
import '../models/book.dart';
import 'book_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<int> favoriteIds;
  final List<Book> allBooks;

  const FavoritesScreen(
      {super.key, required this.favoriteIds, required this.allBooks});

  void _navigateToBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteBooks =
        allBooks.where((book) => favoriteIds.contains(book.id)).toList();

    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          isBooksPage: false,
          onTapBooks: () {
            Navigator.pop(context);
          },
          onTapFavorites: () {},
        ),
        body: ListView.separated(
          itemCount: favoriteBooks.length,
          itemBuilder: (BuildContext context, int index) {
            final currentBook = favoriteBooks[index];
            return ListTile(
              title: Text(currentBook.title),
              subtitle: Text(currentBook.author),
              leading: Image.network(currentBook.coverUrl),
              onTap: () => _navigateToBookDetails(context, currentBook),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.grey, 
              thickness: 1.0, 
            );
          },
        ),
      ),
    );
  }
}
