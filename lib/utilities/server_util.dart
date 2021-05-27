import 'dart:convert' show json;

/// Utilities
import 'package:http/http.dart' as http;

/// Models
import 'package:moviereviewapp/models/movie_info_model.dart';
import 'package:moviereviewapp/models/movie_model.dart';
import 'package:moviereviewapp/models/review_model.dart';
import 'package:moviereviewapp/models/user_model.dart';


var domain = "http://localhost:5000/api/user";

/// Get User from database
Future<User> getUser(String id) async {
  print('server_utils - getUser: $id');
  var url = Uri.parse('http://localhost:5000/api/user/$id');
  var response = await http.get(url);
  final body = json.decode(response.body);
  return User.fromJson(body);
}

/// Get list of Movies for Trending Page
Future<List<Movie>> getMovies(int page) async {
  print('server_util - getMovies: $page');
  /// Get movie data for this [page]
  var url = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US&page=$page');
  var response = await http.get(url);
  /// Deserialise reponse body to json
  final body = json.decode(response.body);
  /// Convert json to list of Movies and return them
  return ((body['results'] as List).map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList());
}

/// Get list of Movies for user's [watchlist]
Future<List<Movie>> getWatchlistMovies(List<int> watchlist) async {
  print('server_util - getWatchlistMovies');
  List<Movie> _movies = [];
  for (int i in watchlist) {
    var url = Uri.parse('https://api.themoviedb.org/3/movie/$i?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');  
    var response = await http.get(url);
    final body = json.decode(response.body);
    _movies.add(Movie.fromJson(body));
  }
  return _movies;
}

/// Get information about movie from The Movie Database
Future<MovieInfo> getMovieInfo(int movieId) async {
  print('server_util - getMovieInfo: $movieId');
  var url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');
  var response = await http.get(url);
  final body = json.decode(response.body);
  return MovieInfo.fromJSON(body);
}

/// Add or remove movie to user's watchlist
Future<void> addRemoveToWatchlist(List<int> watchlist, int i) async {
  print('server_util - addRemoveToWatchlist: $i');
  var url = Uri.parse('$domain/e0d41103-d763-455c-8232-956206005d3d/watchlist?movie_id=$i');
  /// If watchlist already contains this movie, remove it
  if (watchlist.contains(i)) {
    print('addRemoveToWatchlist - delete');
    await http.delete(url);
  } else { /// else, add to watchlist
  print('addRemoveToWatchlist - add');
    await http.put(url);
  }
}

/// Get list of Reviews written by user
Future<List<Review>> getUserReviews(String id) async {
  print('server_util - getUserReviews: $id');
  var url = Uri.parse('$domain/review/user/$id');
  var response = await http.get(url);
  final body = json.decode(response.body);
  return ((body as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList()); 
}

/// Post Review to database
Future<void> postReview(Review review) async {
  print('server_util - postReview');
  var url = Uri.parse('$domain/review?user_id=${review.userId}&movie_id=${review.movieId}');
  String str = json.encode(review.toMap());
  var response = await http.post(url, headers: { 'Content-Type': 'application/json', }, body: str);
  print(response.body);
}

/// Delete Review
Future<void> deleteReview(String id) async {
  print('server_util - postReview');
  var url = Uri.parse('$domain/review?review_id=$id');
  var response = await http.delete(url);
  print(response.body);
}

Future<List<Review>> getReviewsForMovie(int i) async {
  print('server_util - getReviewsForMovie: $i');
  var url = Uri.parse('$domain/review/movie/$i');
  var response = await http.get(url);
  final body = json.decode(response.body);
  return ((body as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList()); 
}