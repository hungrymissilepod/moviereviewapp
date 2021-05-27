/// Bloc
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/models/user_repository.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;

/// Models
import 'package:moviereviewapp/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(UserInitial());

  final UserRepository _userRepository;

  Future<void> getUser(String id) async {
    emit(UserLoading());
    final user = await _userRepository.fetchUser(id);
    emit(UserLoaded(user));
    // TODO: handle errors here - could have network error when getting user
  }

  // TODO: still need to get this updating the wishlist screen properly
  addMovieToWatchlist(User user, int i) {
    print('addMovieToList');
    // user.watchlist.add(i);

    if (user.watchlist.contains(i)) {
      user.watchlist.remove(i);
      user.movies.removeWhere((element) => element.id == i);
    } else {
      server_util.addRemoveToWatchlist(user.watchlist, i);
      user.watchlist.add(i);
    }

    emit(UserLoaded(user));
  }

  /// Change user id to [id]. For testing purposes
  // void changeUser(String id) {
  //   emit(User(id: id));
  //   loadUser();
  // }

  // /// Set the User object in this Cubit
  // void setUser(User u) {
  //   if (state.id != u.id || state.username != u.username) {
  //     emit(u);
  //   }
  // }

  // void addRemoveToWatchlist(int i) {
  //   /// Add to watchlist if not already in watchlist
  //   if (!state.watchlist.contains(i)) {
  //     state.watchlist.add(i);
  //   } else { /// Else remove from watchlist
  //     state.watchlist.remove(i);
  //   }
  //   emit(state);
  //   loadMovies();
  // }

  // Future loadMovies() async {
  //   state.movies = await server_util.getWatchlistMovies(state.watchlist);
  //   emit(state);
  // }

  // /// Load User from database
  // Future<void> loadUser() async {
  //   print('cubit - loadUser');
  //   var url = Uri.parse('http://localhost:5000/api/user/${state.id}');
  //   var response = await http.get(url);
  //   final body = json.decode(response.body);

  //   // User u = User.fromJson(body);
  //   // u.movies = await server_util.getWatchlistMovies(u.watchlist);
  //   // setUser(u);


  //   setUser(User.fromJson(body));
  //   loadMovies();
  // }

}