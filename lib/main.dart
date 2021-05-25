import 'package:flutter/material.dart';
import 'dart:convert' show json;

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';
import 'package:http/http.dart' as http;

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/counter_cubit.dart';

/// Models
import 'package:moviereviewapp/models/movie_model.dart';

/// Widgets
import 'package:moviereviewapp/widgets/movie_poster_widget.dart';

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
          color: Color(kAccentColour),
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


/// TODO: move to own widget file
/// TODO: change app bar title to "Trending"
class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> with AutomaticKeepAliveClientMixin {

  /// ScrollController so we can detect when user is near the bottom of the screen
  ScrollController _controller = ScrollController();

  /// Future for FutureBuilder so we can wait until movies have loaded
  Future _future;

  /// List of [Movie] objects we will display in scroll view
  List<Movie> _movies = [];
  
  /// The current page of data we are loading from API
  int _page = 0;

  /// Are we currently loading data from the API? Helps reduce the amount of data loaded at once
  bool _isLoading = false;
  
  Future getMovies() async {
    setState(() { _isLoading = true; _page++; });
    print('getMovies - page: $_page');

    /// Get movie data for this [_page]
    var url = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US&page=$_page');
    var response = await http.get(url);
    
    /// Deserialise reponse body to json
    final body = json.decode(response.body);
    /// Convert json to list of movies and add them to [_movies] list
    _movies.addAll((body['results'] as List).map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList());

    setState(() { _isLoading = false; });
    return _movies;
  }

  /// Ensure that this widget stays alive so we don't rebuild it when changing page
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _future = getMovies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onScroll() {
    /// When user gets near the bottom of the list, load more movies
    if(_controller.position.extentAfter < 500) {
      if (!_isLoading) { getMovies(); }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double gridPadding = SizeConfig.blockSizeHorizontal * 3;
    print('build - TrendingPage');
    super.build(context);
    return SafeArea(
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: gridPadding),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: _controller,
                slivers: [
                  SliverAppBar(
                    brightness: Brightness.dark,
                    backgroundColor: Color(kBackgroundColour),
                    toolbarHeight: SizeConfig.blockSizeVertical * 22,
                    title: Container(
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('assets/movie_reel.png'),
                            height: SizeConfig.blockSizeVertical * 6,
                          ),
                          Text(
                            'REEL DEALS',
                            style: TextStyle(
                              fontFamily: 'CFParis',
                              color: Color(kAccentColour),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              fontSize: 70,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Find the best movie deals for you',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1/1.5,
                      crossAxisSpacing: gridPadding,
                      mainAxisSpacing: gridPadding,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return MoviePoster(
                          _movies[index].title,
                          _movies[index].voteAverage,
                          _movies[index].imageUrl,
                        );
                      },
                      childCount: _movies.length,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}