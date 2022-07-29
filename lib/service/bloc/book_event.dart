part of 'book_bloc.dart';


abstract class BookEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class BooksFetched extends BookEvent {}

class BooksPersisted extends BookEvent {}

class BookLiked extends BookEvent {
  BookLiked(this.book);

  final Book book;
}
