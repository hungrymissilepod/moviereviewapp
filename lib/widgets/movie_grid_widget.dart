import 'package:flutter/material.dart';

/// Models
import 'package:moviereviewapp/models/movie_model.dart';

/// Widgets
import 'package:moviereviewapp/widgets/movie_poster_widget.dart';

class MovieGrid extends StatelessWidget {

  MovieGrid(this.movies, this.gridPadding);
  final List<Movie> movies;
  final double gridPadding;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1/1.5,
        crossAxisSpacing: gridPadding,
        mainAxisSpacing: gridPadding,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return MoviePoster(
            movies[index].title,
            movies[index].voteAverage,
            movies[index].imageUrl,
            movies[index],
          );
        },
        childCount: movies.length,
      ),
    );
  }
}