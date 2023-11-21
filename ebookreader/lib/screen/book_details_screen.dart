import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/book.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  BookDetailsScreen({required this.book});

  Future<bool> _isBookDownloaded() async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/${book.title}.epub';
    return File(filePath).exists();
  }

  Future<void> _downloadBook(BuildContext context) async {
    final isDownloaded = await _isBookDownloaded();

    if (!isDownloaded) {
      final url = book.downloadUrl;
      final response = await http.get(Uri.parse(url));

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/${book.title}.epub';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro baixado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro já baixado!')),
      );
    }
  }

  Future<void> _readBook(BuildContext context) async {
    final isDownloaded = await _isBookDownloaded();

    if (!isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, baixe o livro para lê-lo!')),
      );
    } else {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/${book.title}.epub';

      try {
        VocsyEpub.setConfig(
          themeColor: Theme.of(context).primaryColor,
          identifier: book.title,
          scrollDirection: EpubScrollDirection.VERTICAL,
          allowSharing: true,
          enableTts: true,
        );

        VocsyEpub.open(filePath);
      } catch (e) {
        print('Erro ao abrir o livro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao abrir o livro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Livro'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(book.coverUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Autor: ${book.author}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _downloadBook(context);
                },
                child: const Text('Baixar Livro'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _readBook(context);
                },
                child: const Text('Ler Livro'),
              ),
            ],
          )),
    );
  }
}
