import 'package:bookstore/screens/book_page.dart';
import 'package:bookstore/service/bloc/book_bloc.dart';
import 'package:bookstore/service/bloc/simple_bloc_observer.dart';
import 'package:bookstore/service/dao/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.init();
  getIt.registerSingleton<BookBloc>(
    BookBloc(httpClient: http.Client())
      ..add(
        BooksFetched(),
      ),
  );
  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends MaterialApp {
  MyApp({Key? key})
      : super(
          key: key,
          home: BooksPage(),
          debugShowCheckedModeBanner: false,
        );
}
