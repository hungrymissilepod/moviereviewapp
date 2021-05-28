// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moviereviewapp/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart' as http;

import 'package:moviereviewapp/widgets/user_review_widget.dart';

/// Testing
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

/// Bloc + Cubit
import 'package:moviereviewapp/cubit/user_cubit.dart';
import 'package:moviereviewapp/models/user_repository.dart';

/// Utilities
import 'package:moviereviewapp/utilities/ui_constants.dart';

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
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userCubit = UserCubit(mockUserRepository);
  });

  tearDown(() {
    userCubit.close();
  });


  testWidgets('Find FloatingActionButton', (WidgetTester tester) async {

    /// Pump the MyApp widget but with our own BlocProvider (userCubit) so as to override regular app one
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => userCubit,
        child: MaterialApp(
          key: Key('Material Key'),
          title: 'Reel Deal',
        theme: ThemeData(
          canvasColor: Color(kBackgroundColour),
          iconTheme: IconThemeData(
            color: Color(kAccentColour), /// accent
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color(kNavigationBarColour),
            selectedIconTheme: IconThemeData(color: Color(kAccentColour)),
            selectedItemColor: Color(kAccentColour),
            unselectedIconTheme: IconThemeData(color: Colors.grey),
            unselectedItemColor: Colors.grey,
          ),
          appBarTheme: AppBarTheme(
          ),
          primarySwatch: Colors.red,
          ),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      )
    );

    /// Wait until our mock repository has give us the user data
    await tester.pump(Duration(seconds: 1));
    await tester.pumpAndSettle();

    /// Try to find a widget with the key FAB (floating action button)
    const testKey = ValueKey('FAB');
    expect(find.byKey(testKey), findsOneWidget);

    /// Useful for printing widget tree in console so we can see what is going on
    // debugDumpApp();
  });

  // TODO: make another test that will find and click the FAB

  // TODO: make another test that will navigate to Profile page and delete a review

  // TODO: make another test that will select a movie, write and validate review and submit it

  // TODO: make another test that will select a movie and add or remove to watchlist
}
