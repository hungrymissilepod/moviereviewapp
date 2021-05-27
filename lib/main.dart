import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';

/// Models
import 'package:moviereviewapp/models/user_model.dart';

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
      create: (context) => UserCubit(),
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
    _future = BlocProvider.of<UserCubit>(context).loadUser();
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
    return BlocBuilder<UserCubit, User>(
      builder: (context, user) {
        print('main - build - ${BlocProvider.of<UserCubit>(context).state.id}');
        return FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print('main - future done');
              return Scaffold(
                // * FAB button as a way to alternate accounts. For development purposes only!
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () { BlocProvider.of<UserCubit>(context).changeUser('f0d64d51-e46b-41ac-95a8-621dbe806409'); },
                // ),
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
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );

    // return FutureBuilder(
    //   future: _future,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       print('main - future done');
    //       return Scaffold(
    //         // * FAB button as a way to alternate accounts. For development purposes only!
    //         floatingActionButton: FloatingActionButton(
    //           onPressed: () { BlocProvider.of<UserCubit>(context).changeUser('f0d64d51-e46b-41ac-95a8-621dbe806409'); },
    //         ),
    //         body: BlocBuilder<UserCubit, User>( /// use BlocBuilder here so children are rebuilt when changing user
    //           builder: (context, id) {
    //             return PageView(
    //               controller: _pageController,
    //               children: [
    //                 WatchlistPage(),
    //                 TrendingPage(),
    //                 ProfilePage(),
    //               ],
    //             );
    //           },
    //         ),
    //         bottomNavigationBar: BottomNavigationBar(
    //           onTap: _onNavBarItemTapped,
    //           currentIndex: _currentPage,
    //           items: [
    //             BottomNavigationBarItem(
    //               label: 'Watchlist',
    //               icon: Icon(Icons.bookmark),
    //             ),
    //             BottomNavigationBarItem(
    //               label: 'Trending',
    //               icon: Icon(Icons.theaters),
    //             ),
    //             BottomNavigationBarItem(
    //               label: 'Profile',
    //               icon: Icon(Icons.person_rounded),
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}