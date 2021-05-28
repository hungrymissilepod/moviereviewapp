import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';

/// Widgets
import 'package:moviereviewapp/widgets/movie_grid_widget.dart';

class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    double gridPadding = SizeConfig.blockSizeHorizontal * 3;
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return SafeArea(
            child: Padding(
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
                  MovieGrid(state.user.movies, gridPadding),
                ],
              ),
            ),
          );
        }
        return Scaffold(body: Container(child: Text('Failed to load watchlist')));
      }
    );
  }
}