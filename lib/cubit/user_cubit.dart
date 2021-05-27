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

  /// When user toggles to add or remove movie from watchlist
  toggleMovieInWatchlist(User user, int i) async {
    /// If this movie is already in watchlist, remove it
    if (user.watchlist.contains(i)) {
      user.watchlist.remove(i);
      user.movies.removeWhere((element) => element.id == i);
      await server_util.removeMovieFromWatchlist(user.id, i);
    } else {
      user.watchlist.add(i);
      await server_util.addMovieToWatchlist(user.id, i);
      user.movies.add(await server_util.getMovieById(i));
    }

    emit(UserLoaded(user));
  }

  
  /// The current test account signed in
  int _currentUser = 0;

  /// Alternate user - for testing
  Future<void> alternateUser() async {
    final user = await _userRepository.fetchUser(_getNextUserId());
    emit(UserLoaded(user));
  }

  String _getNextUserId() {
    switch (_currentUser) {
      case 0:
        _currentUser = 1;
        return 'e0d41103-d763-455c-8232-956206005d3d';
      case 1:
        _currentUser = 2;
        return '6d95bf83-8fb3-43b3-8fba-d5792b52d75f';
      case 2:
        _currentUser = 0;
        return 'f0d64d51-e46b-41ac-95a8-621dbe806409';
      default:
        _currentUser = 0;
        return 'f0d64d51-e46b-41ac-95a8-621dbe806409';
    }
  }
}