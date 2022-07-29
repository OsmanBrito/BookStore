part of 'book_bloc.dart';

enum BookStatus { initial, success, failure }

class BookState extends Equatable {
  const BookState({
    this.status = BookStatus.initial,
    this.books = const <Book>[],
    this.favoriteBooks = const <Book>[],
    this.hasReachedMax = false,
    this.showFavoriteBooks = false,
  });

  final BookStatus status;
  final List<Book> books;
  final List<Book> favoriteBooks;
  final bool hasReachedMax;
  final bool showFavoriteBooks;

  BookState copyWith({
    BookStatus? status,
    List<Book>? books,
    List<Book>? favoriteBooks,
    bool? hasReachedMax,
    bool? showFavoriteBooks,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      showFavoriteBooks: showFavoriteBooks ?? this.showFavoriteBooks,
    );
  }

  @override
  String toString() {
    return '''BookState { status: $status, has in limit: $hasReachedMax, books: ${books.length} }''';
  }

  @override
  List<Object> get props => [status, books, hasReachedMax, showFavoriteBooks, favoriteBooks];
}
