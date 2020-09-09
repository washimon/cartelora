import 'dart:async';
import 'dart:convert';

import 'package:cartelora/src/models/genre.dart';
import 'package:http/http.dart' as http;

import 'package:cartelora/src/models/movie.dart';

class MovieProvider {

  final String _authority = 'api.themoviedb.org';
  final String _apiKey = '493d8c1a5599b2a0402349857c6fa15f';
  final String _language = 'es-ES';
  final List<Movie> movies = List();
  final int _pageNowPlaying = 1;
  int _pagePopular = 0;
  int _pageTopRated = 0;
  int _pageUpcoming = 0;
  bool _saving = false;
  // Streams
  final _popularMoviesStream = StreamController<List<Movie>>.broadcast();

  Stream<List<Movie>> get popularStream => _popularMoviesStream.stream;
  Function(List<Movie>) get _popularSink => _popularMoviesStream.sink.add;

  void dispose() {
    _popularMoviesStream?.close();
  }
  // Futures
  Future<void> getPopular() async {
    if (_saving) return;
    _saving = true;
    _pagePopular++;
    final pelis = await processHttpRequest('popular', _pagePopular);
    movies.addAll(pelis);
    _popularSink(movies);
    _saving = false;
    print('$_pagePopular, ${_saving.toString()}');
  }
  
  Future<List<Movie>> getNowPlaying() async => await processHttpRequest('now_playing', _pageNowPlaying);
  Future<List<dynamic>> getTopRated() async => await processHttpRequest('top_rated', _pageTopRated);
  Future<List<dynamic>> getUpcoming() async => await processHttpRequest('upcoming', _pageUpcoming);

  Future<List<Movie>> processHttpRequest(String typeMovie, int page) async {
    
    final _uri = Uri.https(_authority, '3/movie/$typeMovie', { 'api_key': _apiKey, 'language': _language, 'page': page.toString() });
    final resp = await http.get(_uri);
    final decodedData = json.decode(resp.body);
    // print(decodedData);
    if (decodedData['success'] != null) return [];
    List<Movie> movies = Movies.fromJsonList(decodedData['results']).items;

    return movies;
  }

  Future<List<Genre>> getGenres() async {
    final _uri = Uri.https(_authority, '3/genre/movie/list', { 'api_key': _apiKey, 'language': _language });
    final resp = await http.get(_uri);
    final decodedData = json.decode(resp.body);
    // print(decodedData);
    if (decodedData['success'] != null) return [];
    List<Genre> genres = Genres.fromJsonList(decodedData['genres']).genres;

    return genres;
  }
}