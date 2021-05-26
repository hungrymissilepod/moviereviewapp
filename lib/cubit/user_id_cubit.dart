import 'package:flutter_bloc/flutter_bloc.dart';

/// Models
import 'package:moviereviewapp/models/user_model.dart';

class UserCubit extends Cubit<User> {
  /// Default to user amy_r01 for testing
  UserCubit() : super(User(id: 'e0d41103-d763-455c-8232-956206005d3d'));

  /// Change user id to [id]. For testing purposes
  void changeUser(String id) {
    emit(User(id: id));
  }

  /// Set the User object in this Cubit
  void setUser(User u) {
    if (state.id != u.id || state.username != u.username) {
      emit(u);
    }
  }

  void addToWatchlist(int i) {
    /// Add to watchlist if not already in watchlist
    if (!state.watchlist.contains(i)) {
      state.watchlist.add(i);
    } else { /// Else remove from watchlist
      print('watchlist remove: $i');
      state.watchlist.remove(i);
    }
    emit(state);
  }
}