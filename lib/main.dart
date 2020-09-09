import 'package:flutter/material.dart';

import 'package:cartelora/src/pages/home_page.dart';
import 'package:cartelora/src/pages/movie_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Cartelora',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'movie': (BuildContext context) => MoviePage(),
      },
    );
  }
}