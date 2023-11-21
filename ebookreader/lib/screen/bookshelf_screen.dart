import 'package:ebookreader/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import 'book_details_screen.dart';
import 'favorites_screen.dart';
import '../utils/constants.dart';

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({super.key});

  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late List<Book> books;
  late Set<int> favoriteIds;
  bool isBooksPage = true;

  @override
  void initState() {
    super.initState();
    books = [];
    favoriteIds = {};
    fetchBooks();
    loadFavoriteIds();
  }

  Future<void> fetchBooks() async {
    final response =
        await http.get(Uri.parse(Constants.booksUrl));

    if (response.statusCode == 200) {
      final List<dynamic> booksJson = jsonDecode(response.body);

      setState(() {
        books =
            booksJson.map<Book>((bookJson) => Book.fromJson(bookJson)).toList();
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> loadFavoriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favoriteIds');

    if (favorites != null) {
      setState(() {
        favoriteIds = favorites.map<int>((id) => int.parse(id)).toSet();
      });
    }
  }

  Future<void> saveFavoriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favoriteIds', favoriteIds.map((id) => id.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBooksPage: isBooksPage,
        onTapBooks: () {
          setState(() {
            isBooksPage = true;
          });
        },
        onTapFavorites: () {
          if (isBooksPage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesScreen(
                  favoriteIds: favoriteIds,
                  allBooks: books,
                ),
              ),
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            final isFavorite = favoriteIds.contains(books[index].id);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(book: books[index]),
                  ),
                );
              },
              child: Card(
                elevation: 0.0,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRect(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0), 
                              width: 2.0, 
                            ),
                            borderRadius: BorderRadius.circular(
                                12.0), 
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Image.network(
                              books[index].coverUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            favoriteIds.remove(books[index].id);
                          } else {
                            favoriteIds.add(books[index].id);
                          }
                          saveFavoriteIds();
                        });
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              books[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Autor: ${books[index].author}', 
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
