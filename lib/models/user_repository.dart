/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;

/// Models
import 'package:moviereviewapp/models/user_model.dart';

class UserRepository {
  
  /// Get User from database
  Future<User> fetchUser(String id) async {
    User user = await server_util.getUser(id);
    /// Download user watchlist movies
    user.movies = await server_util.getWatchlistMovies(user.watchlist);
    return user;
  }
}