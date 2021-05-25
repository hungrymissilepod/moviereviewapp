import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/counter_cubit.dart';

/// Widgets
import 'package:moviereviewapp/widgets/trending_page_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          // color: Color(kAccentColour),
          // backgroundColor: Colors.black,
          brightness: Brightness.dark,
          color: Colors.orange,

        ),
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => CounterCubit(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentPage = 1;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _currentPage = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          WatchlistPage(),
          TrendingPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onNavBarItemTapped,
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(
            label: 'Watchlist',
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            label: 'Trending',
            icon: Icon(Icons.theaters),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_rounded),
          ),
        ],
      ),
      // body: BlocBuilder<CounterCubit, int>(
      //   builder: (context, count) {
      //     return Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           Text('You have pushed the button this many times:'),
      //           Text('$count', style: Theme.of(context).textTheme.headline4),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => context.read<CounterCubit>().increment(),
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // TODO: user info. image, username, location, bio, etc
          Container(
            child: Text('user info here'),
          ),
          // TODO: user movie reviews and comments here
          Container(
            child: Column(
              children: [
                Text('movie review 1'),
                Text('movie review 2'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: use futurebuilder here to display list of movies user has added to their watchlist
class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(child: Text('watchlist'),),
    );
  }
}