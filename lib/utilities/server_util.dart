import 'dart:convert' show json;

/// Utilities
import 'package:http/http.dart' as http;

/// Models
import 'package:moviereviewapp/models/movie_info_model.dart';
import 'package:moviereviewapp/models/movie_model.dart';
import 'package:moviereviewapp/models/review_model.dart';
import 'package:moviereviewapp/models/user_model.dart';


// var domain = "http://localhost:5000/api/user"; /// test domain
var domain = "https://jakemoviereviewserver.herokuapp.com/api/user";

/// Get User from database
Future<User> getUser(String id, { http.Client client }) async {
  print('server_utils - getUser: $id');
  var url = Uri.parse('$domain/$id');
  http.Response response;

  /// This method is used for unit testing so we have to check if http.Client has been supplied (mock client) or not
  if (client == null) { response = await http.get(url); }
  else { response = await client.get(url); }

  /// If we get a good response from server
  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('getUser - Bad response from server');
  }
}

/// Get list of Movies for Trending Page
Future<List<Movie>> getMovies(int page) async {
  print('server_util - getMovies: $page');
  /// Get movie data for this [page]
  var url = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US&page=$page');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    /// Deserialise reponse body to json
    final body = json.decode(response.body);
    /// Convert json to list of Movies and return them
    return ((body['results'] as List).map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList());
  } else { throw Exception('getMovies - Bad response from server'); }
}

/// Get list of Movies for user's [watchlist]
Future<List<Movie>> getWatchlistMovies(List<int> watchlist) async {
  print('server_util - getWatchlistMovies');
  List<Movie> _movies = [];
  for (int i in watchlist) {
    var url = Uri.parse('https://api.themoviedb.org/3/movie/$i?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');  
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      _movies.add(Movie.fromJson(body));
    }
  }
  return _movies;
}

/// Get on Movie by [id]
Future<Movie> getMovieById(int id) async {
  print('server_util - getMovieById: $id');
  var url = Uri.parse('https://api.themoviedb.org/3/movie/$id?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');  
  var response = await http.get(url);
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return Movie.fromJson(body);
  } else { throw Exception('getMovieById - Bad response from server'); }
}

/// Get information about movie from The Movie Database
Future<MovieInfo> getMovieInfo(int movieId) async {
  print('server_util - getMovieInfo: $movieId');
  var url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return MovieInfo.fromJSON(body);
  } else { throw Exception('getMovieInfo - Bad response from server'); }
}

/// Add a movie with [id] to user watchlist
Future<void> addMovieToWatchlist(String userId, int movieId) async {
  print('server_util - addMovieToWatchList: $movieId');
  var url = Uri.parse('$domain/$userId/watchlist?movie_id=$movieId');
  await http.put(url);
}

/// Add a movie with [id] from user watchlist
Future<void> removeMovieFromWatchlist(String userId, int movieId) async {
  print('server_util - removeMovieFromWatchlist: $movieId');
  var url = Uri.parse('$domain/$userId/watchlist?movie_id=$movieId');
  await http.delete(url);
}

/// Get list of Reviews written by user
Future<List<Review>> getUserReviews(String id) async {
  print('server_util - getUserReviews: $id');
  var url = Uri.parse('$domain/review/user/$id');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return ((body as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList()); 
  } else { throw Exception('getUserReviews - Bad response from server'); }
}

/// Post Review to database
Future<void> postReview(Review review) async {
  print('server_util - postReview');
  var url = Uri.parse('$domain/review?user_id=${review.userId}&movie_id=${review.movieId}');
  String str = json.encode(review.toMap());
  var response = await http.post(url, headers: { 'Content-Type': 'application/json', }, body: str);
  if (response.statusCode != 200) throw Exception('postReview - Bad response from server');
}

/// Delete Review
Future<void> deleteReview(String id) async {
  print('server_util - postReview');
  var url = Uri.parse('$domain/review?review_id=$id');
  await http.delete(url);
}

Future<List<Review>> getReviewsForMovie(int i) async {
  print('server_util - getReviewsForMovie: $i');
  var url = Uri.parse('$domain/review/movie/$i');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return ((body as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList());
  } else { throw Exception('getReviewsForMovie - Bad response from server'); }
}