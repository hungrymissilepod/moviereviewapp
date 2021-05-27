import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:moviereviewapp/utilities/size_config.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';

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

  /// Get movies for user's watchlist
  Future getMovies() async {
    _movies.clear();
    List<int> watchlist = BlocProvider.of<UserCubit>(context, listen: true).state.watchlist;
    if (watchlist == null) return;
    return _movies = await server_util.getWatchlistMovies(watchlist);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    );
  }
}