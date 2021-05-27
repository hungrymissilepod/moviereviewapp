/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;

/// Models
import 'package:moviereviewapp/models/user_model.dart';

class UserRepository {

  Future<User> fetchUser(String id) async {
    /// Get User from database
    User user = await server_util.getUser(id);
    /// Download user watchlist movies
    user.movies = await server_util.getWatchlistMovies(user.watchlist);
    return user;
  }
}

class NetworkException implements Exception {}