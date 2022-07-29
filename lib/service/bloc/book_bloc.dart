import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../model/book.dart';
import '../dao/shared_preferences.dart';

part 'book_event.dart';

part 'book_state.dart';

const _q = "flutter";
const _maxResults = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class BookBloc extends Bloc<BookEvent, BookState> {
  int _startIndex = 0;
  final http.Client httpClient;

  BookBloc({required this.httpClient}) : super(const BookState()) {
    on<BooksFetched>(
      _onBookFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<BooksPersisted>(
      _onBookPersisted,
      transformer: throttleDroppable(throttleDuration),
    );
    on<BookLiked>(
      _onBookLiked,
    );
  }

  Future<void> _onBookFetched(
      BooksFetched event, Emitter<BookState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == BookStatus.initial) {
        final books = await _fetchBooks();
        return emit(state.copyWith(
          status: BookStatus.success,
          books: books,
          hasReachedMax: false,
        ));
      }
      final books = await _fetchBooks();
      emit(books.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BookStatus.success,
              books: List.of(state.books)..addAll(books),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: BookStatus.failure));
    }
  }

  Future<void> _onBookPersisted(
      BooksPersisted event, Emitter<BookState> emit) async {
    if (MySharedPreferences.getFavoriteBooks().isEmpty) {
      return emit(
        state.copyWith(
          favoriteBooks: [],
          showFavoriteBooks: !state.showFavoriteBooks,
        ),
      );
    } else {
      final persistedBooks = jsonDecode(MySharedPreferences.getFavoriteBooks());
      List<Book> favoriteBooks = [];
      favoriteBooks =
          persistedBooks.map((b) => Book.fromJson(b)).toList().cast<Book>();
      emit(
        state.copyWith(
          favoriteBooks: favoriteBooks,
          showFavoriteBooks: !state.showFavoriteBooks,
          hasReachedMax: false,
        ),
      );
    }
  }

  Future<void> _onBookLiked(BookLiked event, Emitter<BookState> emit) async {
    event.book.isFavorite = !event.book.isFavorite;
    var favoriteBooks = <Book>[];
    if (MySharedPreferences.getFavoriteBooks().isEmpty) {
      favoriteBooks.add(event.book);
      MySharedPreferences.insert(json.encode(favoriteBooks));
    } else {
      if (!event.book.isFavorite) {
        state.favoriteBooks.removeWhere((b) => b.id == event.book.id);
        event.book.isFavorite = false;
        MySharedPreferences.insert(jsonEncode(state.favoriteBooks));
        emit(
          state.copyWith(
            showFavoriteBooks: false,
            favoriteBooks: state.favoriteBooks,
          ),
        );
      } else {
        final persistedBooks =
            jsonDecode(MySharedPreferences.getFavoriteBooks());
        favoriteBooks =
            persistedBooks.map((b) => Book.fromJson(b)).toList().cast<Book>();
        favoriteBooks.add(event.book);
        MySharedPreferences.insert(json.encode(favoriteBooks));
        emit(
          state.copyWith(
            favoriteBooks: favoriteBooks,
          ),
        );
      }
    }
  }

  Future<List<Book>> _fetchBooks() async {
    final response = await httpClient.get(
      Uri.https(
        'www.googleapis.com',
        '/books/v1/volumes',
        <String, String>{
          'q': _q,
          'maxResults': '$_maxResults',
          'startIndex': '$_startIndex',
          'orderBy': 'relevance',
        },
      ),
    );
    if (response.statusCode == 200) {
      _startIndex++;
      final body = json.decode(response.body)["items"] as List;
      return body.map((dynamic json) {
        return Book(
            id: json['id'],
            title: json['volumeInfo']['title'] ??= "",
            author: Book.getAuthorsSafety(json['volumeInfo']['authors']),
            description: json['volumeInfo']['description'] ??= "",
            bookUrl: json['volumeInfo']['previewLink'] ??= "",
            thumbnail:
                Book.getThumbnailSafety(json).replaceAll("http", "https"),
            isFavorite:
                MySharedPreferences.getFavoriteBooks().contains(json['id']));
      }).toList();
    }
    throw Exception('error fetching books');
  }
}
