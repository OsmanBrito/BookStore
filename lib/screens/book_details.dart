import 'package:bookstore/service/bloc/book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/book.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  GetIt getIt = GetIt.instance;

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(widget.book.bookUrl!))) {
      throw 'Could not launch ${widget.book.bookUrl}';
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Alterar aqui o appbar pra ter em todos.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.book.id!,
                  child: Image.network(widget.book.thumbnail!),
                ),
                Text(
                  widget.book.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  widget.book.author!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    getIt<BookBloc>().add(BookLiked(widget.book));
                  }),
                  child: widget.book.isFavorite
                      ? const Icon(
                          Icons.favorite,
                          size: 36,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          size: 36,
                        ),
                ),
                Text(widget.book.description!),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _launchUrl,
                    child: const Text("Comprar"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
