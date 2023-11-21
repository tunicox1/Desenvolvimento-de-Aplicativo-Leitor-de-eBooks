import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBooksPage;

  final Function() onTapBooks;
  final Function() onTapFavorites;

  const CustomAppBar({
    super.key,
    required this.isBooksPage,
    required this.onTapBooks,
    required this.onTapFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onTapBooks,
            child: Text(
              'Livros',
              style: TextStyle(
                fontWeight: isBooksPage ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTapFavorites,
            child: Text(
              'Favoritos',
              style: TextStyle(
                fontWeight: isBooksPage ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
