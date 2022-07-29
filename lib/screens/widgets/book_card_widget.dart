import 'package:bookstore/model/book.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:bookstore/service/bloc/book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCardWidget extends StatefulWidget {
  const BookCardWidget({
    super.key,
    required this.book,
    required this.showHearth,
  });

  final Book book;
  final bool showHearth;

  @override
  State<BookCardWidget> createState() => _BookCardWidgetState();
}

class _BookCardWidgetState extends State<BookCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookDetails(book: widget.book),
            ),
          );
        });
      },
      child: SizedBox(
        child: Card(
          margin: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.book.title!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Hero(
                tag: widget.book.id!,
                child: Image.network(
                  widget.book.thumbnail!,
                  height: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
