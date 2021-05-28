/// Bloc
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/models/user_repository.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:equatable/equatable.dart';

/// Models
import 'package:moviereviewapp/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(UserInitial());

  final UserRepository _userRepository;

  Future<void> getUser(String id) async {
    emit(UserLoading());
    try {
      final user = await _userRepository.fetchUser(id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Failed to get user'));
    }
  }

  /// When user toggles to add or remove movie from watchlist
  toggleMovieInWatchlist(User user, int i) async {
    /// If this movie is already in watchlist, remove it
    if (user.watchlist.contains(i)) {
      user.watchlist.remove(i);
      /// Remove this movies from user's movie list
      int index = user.movies?.indexWhere((e) => e.id == i);
      if (index != -1 && index != null) { user.movies.removeAt(index); }
      await server_util.removeMovieFromWatchlist(user.id, i);
    } else {
      user.watchlist.add(i);
      await server_util.addMovieToWatchlist(user.id, i);
      user.movies.add(await server_util.getMovieById(i));
    }
  }


  /// Test accounts
  List<String> _testAccounts = [ 'f0d64d51-e46b-41ac-95a8-621dbe806409', 'e0d41103-d763-455c-8232-956206005d3d', '6d95bf83-8fb3-43b3-8fba-d5792b52d75f' ];

  /// The current test account signed in
  int _currentUser = 0;

  /// Alternate user - for testing
  Future<void> alternateUser() async {
    emit(UserLoading());
    /// Increment user account
    _currentUser++;
    if (_currentUser > _testAccounts.length-1) { _currentUser = 0; }

    final user = await _userRepository.fetchUser(_testAccounts[_currentUser]);
    emit(UserLoaded(user));
  }
}