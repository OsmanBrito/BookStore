import 'package:bookstore/screens/widgets/book_card_widget.dart';
import 'package:bookstore/screens/widgets/bottom_loader_widget.dart';
import 'package:bookstore/service/bloc/book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BooksList extends StatefulWidget {
  const BooksList({Key? key}) : super(key: key);

  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  final _scrollController = ScrollController();
  GetIt getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state.showFavoriteBooks) {
          if (state.favoriteBooks.isEmpty) {
            return const Center(child: Text('no favorite books'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: state.favoriteBooks.length,
              itemBuilder: (BuildContext context, int index) {
                return BookCardWidget(
                  book: state.favoriteBooks[index],
                  showHearth: true,
                );
              },
            );
          }
        } else {
          switch (state.status) {
            case BookStatus.failure:
              return const Center(child: Text('failed to fetch books'));
            case BookStatus.success:
              if (state.books.isEmpty) {
                return const Center(child: Text('no books'));
              } else {
                return GridView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.books.length
                        ? const BottomLoader()
                        : BookCardWidget(
                            book: state.books[index],
                            showHearth: false,
                          );
                  },
                  itemCount: state.hasReachedMax
                      ? state.books.length
                      : state.books.length + 1,
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  void _onScroll() {
    if (_isBottom) getIt<BookBloc>().add(BooksFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
