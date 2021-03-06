import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';

/// Widgets
import 'package:moviereviewapp/widgets/common_widget.dart';

/// Models
import 'package:moviereviewapp/models/movie_model.dart';
import 'package:moviereviewapp/widgets/movie_info_page_widget.dart';

class MoviePoster extends StatelessWidget {
  MoviePoster(this.movie);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(Platform.isIOS) { Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieInfoPage(id: movie.id), settings: RouteSettings(name: 'MovieInfoPage'))); }
        else { Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => MovieInfoPage(id: movie.id), settings: RouteSettings(name: 'MovieInfoPage'))); }
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            child: FittedBox(
              fit: BoxFit.fill,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie.imageUrl}',
                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    return Text('Image failed to load');
                  },
                  ),
                ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ Colors.transparent, Colors.black87.withOpacity(0.35), Colors.black87 ],
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2, horizontal: SizeConfig.blockSizeHorizontal * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    StarRow(movie.voteAverage, showHalfStars: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}