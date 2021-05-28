import 'package:flutter/material.dart';
import 'package:moviereviewapp/models/user_repository.dart';

/// Utilities
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';

/// Widgets
import 'package:moviereviewapp/widgets/watchlist_page_widget.dart';
import 'package:moviereviewapp/widgets/trending_page_widget.dart';
import 'package:moviereviewapp/widgets/profile_page_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(UserRepository()),
      child: MaterialApp(
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future _future;

  PageController _pageController;

  /// Current page shown in PageView
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentPage = 1;
    /// Load default user
    _future = BlocProvider.of<UserCubit>(context).getUser('f0d64d51-e46b-41ac-95a8-621dbe806409');
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
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // TODO: can show messages based on UserState
        // if (state is UserLoaded) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('error'),)
        //   );
        // }
      },
      builder: (context, state) {
        if (state is UserLoaded) {
          print('main - build - ${BlocProvider.of<UserCubit>(context).state}');
          return FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                  /// Use FloatingActionButton to change between test accounts
                  floatingActionButton: _currentPage == 1 ? FloatingActionButton(
                    key: ValueKey('FAB'),
                    onPressed: () { BlocProvider.of<UserCubit>(context).alternateUser(); },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_rounded),
                        Text('Change user', key: ValueKey('changeuserkey'), textAlign: TextAlign.center, style: TextStyle(fontSize: 9),),
                      ],
                    ),
                  ) : Container(),
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
                );
              }
              return Center(key: Key('loading'), child: CircularProgressIndicator());
            },
          );
        } else if (state is UserError) {
          return Center(key:Key('error'), child: Text('Failed to load user data'));
          // TODO: should have a button where user can retry to load data
        } else {
          return Center(key: Key('none'), child: CircularProgressIndicator());
        }
      },
    );
  }
}