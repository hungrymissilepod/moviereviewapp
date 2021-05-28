/// Testing
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

/// Bloc + Cubit
import 'package:moviereviewapp/cubit/user_cubit.dart';
import 'package:moviereviewapp/models/user_repository.dart';

/// Models
import 'package:moviereviewapp/models/user_model.dart';


/// User object created for testing
final user = User(id: "123", username: "jake");

/// Mock UserReposity for testing UserCubit
class MockUserRepository extends Mock implements UserRepository {

  /// Override fetchUser method so it just returns a User object we have created above
  @override
  Future<User> fetchUser(String id) async {
    return Future.delayed(Duration(seconds: 1), () => user);
  }
}

void main() {
  UserCubit userCubit;
  MockUserRepository userRepository;

  group('User Cubit', () {

    setUp(() {
      userRepository = MockUserRepository();
      userCubit = UserCubit(userRepository);
    });

    /// Test that UserCubit loads correctly
    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserLoaded] states in order',
      build: () => userCubit,
      act: (cubit) => cubit.getUser("123"),
      expect: () => [
        UserLoading(),
        UserLoaded(user),
      ],
    );

    tearDown(() {
      userCubit.close();
    });
  });

  /// Tests for user's watchlist
  group('User watchlist', () {

    /// Test adding a movie to watchlist
    test('Add movie to watchlist', () async {
      /// Create user object with empty watchlist
      final u1 = User(id: "123", watchlist: []);
      userCubit.toggleMovieInWatchlist(u1, 0);
      expect(u1.watchlist, [0]);
    });


    /// Test removing a movie from watchlist (use toggle method that will remove movie if watchlist already contains it)
    test('Remove movie from watchlist', () async {
      /// Create user object with some movies in watchlist
      final u1 = User(id: "123", watchlist: [0, 1, 2]);
      /// Toggle movie 2 in watchlist
      userCubit.toggleMovieInWatchlist(u1, 2);
      /// Expect movie 2 to have been removed
      expect(u1.watchlist, [0, 1]);
    });
  });
}