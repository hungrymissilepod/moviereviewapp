import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Movie Review App', () {

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

     // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    /// Try to find FloatingActionButton and tap it
    test('Find and tap FAB', () async {

      final fabFinder = find.byType('FloatingActionButton');
      await driver.tap(fabFinder);
    });

    /// Try to find BottomNavigationBar and select each page
    test('Change page', () async {
      /// Wait until driver finds the BottomNavigationBar
      await driver.waitFor(find.byValueKey('bottomNavBar'));
      /// Tap to go to Watchlist page
      await driver.tap(find.text('Watchlist'));
      /// Tap to go to Profile page
      await driver.tap(find.text('Profile'));
      /// Tap to go to Trending page
      await driver.tap(find.text('Trending'));
    });

  });
}
