import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


/// Models
import 'package:moviereviewapp/models/user_model.dart';

class UserCubit extends Cubit<User> {
  /// Default to user amy_r01 for testing
  UserCubit() : super(User(id: 'e0d41103-d763-455c-8232-956206005d3d'));

  /// Change user id to [id]. For testing purposes
  void changeUser(String id) {
    emit(User(id: id));
    loadUser();
  }

  /// Set the User object in this Cubit
  void setUser(User u) {
    if (state.id != u.id || state.username != u.username) {
      emit(u);
    }
  }

  void addRemoveToWatchlist(int i) {
    /// Add to watchlist if not already in watchlist
    if (!state.watchlist.contains(i)) {
      state.watchlist.add(i);
    } else { /// Else remove from watchlist
      state.watchlist.remove(i);
    }
    emit(state);
  }

  /// Load User from database
  Future<void> loadUser() async {
    print('cubit - loadUser');
    var url = Uri.parse('http://localhost:5000/api/user/${state.id}');
    var response = await http.get(url);
    final body = json.decode(response.body);
    setUser(User.fromJson(body));
  }

}