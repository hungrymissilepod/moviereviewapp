import 'package:flutter/material.dart';
import 'dart:convert' show json;

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';
import 'package:http/http.dart' as http;

/// Models
import 'package:moviereviewapp/models/movie_model.dart';

/// Widgets
import 'package:moviereviewapp/widgets/movie_grid_widget.dart';

class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {

  /// Future for FutureBuilder so we can wait until movies have loaded
  Future _future;

  /// List of [Movie] objects we will display in scroll view
  List<Movie> _movies = [];

  // TODO: mock data
  // TODO: get user's watchlist movies from our server
  /// List of user's watchlist movies
  List<int> _favMovies = [578701, 567189, 399566, 717192, 635302, 791373];

  Future getMovies() async {
    print('getMovies - watchlist');
    for(int i in _favMovies) {
      var url = Uri.parse('https://api.themoviedb.org/3/movie/$i?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');  
      var response = await http.get(url);
      final body = json.decode(response.body);
      _movies.add(Movie.fromJson(body));
    }
    return _movies;
  }

  @override
  void initState() {
    super.initState();
    _future = getMovies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double gridPadding = SizeConfig.blockSizeHorizontal * 3;
    print('build - WatchlistPage');
    return SafeArea(
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: gridPadding),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Color(kBackgroundColour),
                    toolbarHeight: SizeConfig.blockSizeVertical * 10,
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'My Watchlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MovieGrid(_movies, gridPadding),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      // child: Container(child: Text('watchlist'),),
    );
  }
}