import 'package:flutter/material.dart';
import 'dart:convert' show json;

/// Utilities
import 'package:moviereviewapp/utilities/ui_constants.dart';
import 'package:http/http.dart' as http;

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_id_cubit.dart';

/// Models
import 'package:moviereviewapp/models/user_model.dart';

/// Widgets
import 'package:moviereviewapp/widgets/watchlist_page_widget.dart';
import 'package:moviereviewapp/widgets/trending_page_widget.dart';
import 'package:moviereviewapp/widgets/profile_page_widget.dart';

void main() {
  runApp(MyApp());
}
// TODO: in Watchlist screen, load all movies user has in their watchlist

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
    // home: BlocProvider(
    //     create: (context) => UserCubit(),
    //     child: MyHomePage(),
    //   ),
    // return MaterialApp(
    //   title: 'Reel Deal',
    //   theme: ThemeData(
    //     canvasColor: Color(kBackgroundColour),
    //     iconTheme: IconThemeData(
    //       color: Color(kAccentColour), /// accent
    //     ),
    //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //       backgroundColor: Color(kNavigationBarColour),
    //       selectedIconTheme: IconThemeData(color: Color(kAccentColour)),
    //       selectedItemColor: Color(kAccentColour),
    //       unselectedIconTheme: IconThemeData(color: Colors.grey),
    //       unselectedItemColor: Colors.grey,
    //     ),
    //     appBarTheme: AppBarTheme(
    //     ),
    //     primarySwatch: Colors.red,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home: MyHomePage(),
    //   // home: BlocProvider(
    //   //   create: (context) => UserCubit(),
    //   //   child: MyHomePage(),
    //   // ),
    // );
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

  Future _future;

  Future loadUserData() async {
    print('main - loadUserData');
    String id = BlocProvider.of<UserCubit>(context, listen: true).state.id;
    
    /// Load User data
    var url = Uri.parse('http://localhost:5000/api/user/${id}');
    var response = await http.get(url);
    final body = json.decode(response.body);
    print('loadUserData - body: $body');

    /// Convert json to User object
    BlocProvider.of<UserCubit>(context).setUser(User.fromJson(body));
  }

  @override
  void initState() {
    print('main - initState');
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void didChangeDependencies() {
    print('main - didChangeDependencies');
    super.didChangeDependencies();
    _currentPage = 1;
    _future = loadUserData();
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
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            // * FAB button as a way to alternate accounts. For development purposes only!
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () { BlocProvider.of<UserCubit>(context).changeUser('f0d64d51-e46b-41ac-95a8-621dbe806409'); },
            // ),
            body: BlocBuilder<UserCubit, User>( /// use BlocBuilder here so children are rebuilt when changing user
              builder: (context, id) {
                print(id);
                return PageView(
                  controller: _pageController,
                  children: [
                    WatchlistPage(),
                    TrendingPage(),
                    ProfilePage(),
                  ],
                );
              },
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
  }
}