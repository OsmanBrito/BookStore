import 'package:bookstore/service/bloc/book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'books_list.dart';

class BooksPage extends StatelessWidget {
  BooksPage({Key? key}) : super(key: key);

  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<BookBloc>(create: (_) => getIt<BookBloc>())],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Store'),
          actions: [
            IconButton(
              onPressed: () {
                getIt<BookBloc>().add(BooksPersisted());
              },
              icon: BlocBuilder<BookBloc, BookState>(
                bloc: getIt<BookBloc>(),
                builder: (_, state) {
                  return Icon(state.showFavoriteBooks
                      ? Icons.favorite
                      : Icons.favorite_border, color: Colors.red,);
                },
              ),
            ),
          ],
        ),
        body: const BooksList(),
      ),
    );
  }
}
