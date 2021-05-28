import 'package:flutter/material.dart';

/// Testing
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';
import 'package:moviereviewapp/models/user_repository.dart';

/// Utilities
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Models
import 'package:moviereviewapp/models/user_model.dart';
import 'package:moviereviewapp/models/movie_model.dart';

/// Widgets
import 'package:moviereviewapp/main.dart';
import 'package:moviereviewapp/widgets/movie_info_page_widget.dart';
import 'package:moviereviewapp/widgets/movie_poster_widget.dart';
import 'package:moviereviewapp/utilities/size_config.dart';


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

class MockBuildContext extends Mock implements BuildContext {}

/// Useful for printing widget tree in console so we can see what is going on
// debugDumpApp();

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

    /// Expect to find a FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });


  /// Test a movie poster that has a 7/10 rating
  testWidgets('Movie poster stars', (WidgetTester tester) async {
    
    /// First pump the MaterialApp and Scaffold because we need to init SizeConfig
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(),
      ),
    );

    /// Get context from Scaffold
    final BuildContext context = tester.element(find.byType(Scaffold));
    /// Use context to init SizeConfig
    SizeConfig().init(context);

    /// Now pump the tester with the MoviePoster
    await tester.pumpWidget(
      MaterialApp(
        home: MoviePoster(Movie(id: 0, title: 'Test movie', overview: 'sdsds', voteAverage: 7, imageUrl: "")),
      ),
    );
    
    /// If the movie has a 7/10 we expect to see 3 full stars and 1 half star (3.5 stars)
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    expect(find.byIcon(Icons.star_half_rounded), findsNWidgets(1));
  });


  /// Tests for Write Review Dialog
  group('Write Review Dialog', () {

    /// Test submitting a review without entering any data
    testWidgets('Test submitting a review without entering any data', (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(),
        ),
      );
      /// Get context from Scaffold
      final BuildContext context = tester.element(find.byType(Scaffold));
      /// Show WriteReviewDialog dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WriteReviewDialog("123", 12345);
        }
      );
      /// Wait for dialog to be shown
      await tester.pumpAndSettle(Duration(seconds: 1));
      /// Expect to find "Leave a review" title in dialog box
      expect(find.text('Leave a review'), findsOneWidget);
      /// Tap the OK button without entering any information
      await tester.tap(find.text('OK'));
      await tester.pump(Duration(seconds: 1));
      /// We expect the TextFormField validation to trigger and show error text
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    /// Test submitting a review with short body text
    testWidgets('Test submitting a review with short body text', (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(),
        ),
      );
      /// Get context from Scaffold
      final BuildContext context = tester.element(find.byType(Scaffold));
      /// Show WriteReviewDialog dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WriteReviewDialog("123", 12345);
        }
      );
      /// Wait for dialog to be shown
      await tester.pumpAndSettle(Duration(seconds: 1));
      /// Expect to find "Leave a review" title in dialog box
      expect(find.text('Leave a review'), findsOneWidget);
      /// Enter title text
      await tester.enterText(find.byKey(ValueKey('titleTextFormField')), 'Test Movie Title');
      /// Enter short body text
      await tester.enterText(find.byKey(ValueKey('bodyTextFormField')), 'hello');
      /// Tap the OK button to submit review
      await tester.tap(find.text('OK'));
      await tester.pump(Duration(seconds: 1));
      /// We expect the TextFormField validation to trigger and show error text
      expect(find.text('Must have more than 10 characters'), findsOneWidget);
    });
  });
}
