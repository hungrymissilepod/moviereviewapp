import 'package:flutter/material.dart';
import 'dart:convert' show json;

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';
import 'package:http/http.dart' as http;

/// Models
import 'package:moviereviewapp/models/movie_info_model.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Widgets
import 'package:moviereviewapp/widgets/user_review_widget.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_id_cubit.dart';

class MovieInfoPage extends StatefulWidget {
  
  MovieInfoPage({ Key key, @required this.id }) : super(key: key);

  final int id;

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {

  Future _future;
  MovieInfo _movieInfo;

  Future getMovieInfo() async {
    /// Get movie data for this [_page]
    var url = Uri.parse('https://api.themoviedb.org/3/movie/${widget.id}?api_key=8c043f485c2ba60127587c01b27e413d&language=en-US');
    var response = await http.get(url);
    
    /// Deserialise reponse body to json
    final body = json.decode(response.body);
    
    _movieInfo = MovieInfo.fromJSON(body);
    return _movieInfo;
  }

  @override
  void initState() {
    super.initState();
    _future = getMovieInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Add or remove movie to watchlist
  _tapFavouriteButton() async {
    List<int> watchlist = BlocProvider.of<UserCubit>(context).state.watchlist;
    
    var url = Uri.parse('http://localhost:5000/api/user/e0d41103-d763-455c-8232-956206005d3d/watchlist?movie_id=${_movieInfo.id}');

    /// If watchlist already contains this movie, remove it
    if (watchlist.contains(_movieInfo.id)) {
      await http.delete(url);
    } else { /// else, add to watchlist
      await http.put(url);
    }

    setState(() {
      BlocProvider.of<UserCubit>(context).addToWatchlist(_movieInfo.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child : FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              double stars = _movieInfo.voteAverage / 2; /// convert vote score to number of stars
              var user = BlocProvider.of<UserCubit>(context, listen: true).state;
              bool liked = user.watchlist.contains(_movieInfo.id);
              // return CustomScrollView(
              //   physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              //   slivers: [
              //     SliverAppBar(
              //       automaticallyImplyLeading: false,
              //       // floating: true,
              //       // pinned: true,
              //       // stretch: true,
              //       flexibleSpace: FlexibleSpaceBar(
              //         title: Image.network(
              //           'https://image.tmdb.org/t/p/original/${_movieInfo.backdropUri}',
              //           fit: BoxFit.cover,
              //           loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
              //           if (loadingProgress == null) return child;
              //             return Center(child: CircularProgressIndicator());
              //           },
              //         ),
              //         // background: Image.network(
              //         //   'https://image.tmdb.org/t/p/original/${_movieInfo.backdropUri}',
              //         //   fit: BoxFit.fitHeight,
              //         //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
              //         //   if (loadingProgress == null) return child;
              //         //     return Center(child: CircularProgressIndicator());
              //         //   },
              //         // ),
              //       ),
              //       brightness: Brightness.dark,
              //       backgroundColor: Color(kBackgroundColour),
              //       toolbarHeight: SizeConfig.blockSizeVertical * 22,
              //       // title: Image.network(
              //       //   'https://image.tmdb.org/t/p/original/${_movieInfo.backdropUri}',
              //       //   fit: BoxFit.fitHeight,
              //       //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
              //       //   if (loadingProgress == null) return child;
              //       //     return Center(child: CircularProgressIndicator());
              //       //   },
              //       // ),
              //     ),
              //   ],
              // );

              // TODO: use sliver app bar for better UI
              return Column(
                children: [
                  Stack(
                    fit: StackFit.passthrough,
                    children: [
                      // TODO: entire page should only display once image is loaded
                      Container(
                        height: 260,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original/${_movieInfo.backdropUri}',
                          fit: BoxFit.cover,
                          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [ Colors.transparent, Colors.black87.withOpacity(0.35), Colors.black87 ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1, horizontal: SizeConfig.blockSizeHorizontal * 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _movieInfo.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 20,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () { Navigator.of(context).pop(); },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 20,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () { _tapFavouriteButton(); },
                          child: Icon(
                            liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_movieInfo.voteAverage}',
                                style: TextStyle(color: Color(kAccentColour), fontSize: 24),
                              ),
                              SizedBox(width: 10),
                              Row(
                                children: List.generate(5, (index) {
                                  IconData icon = Icons.star_outline_rounded; /// default to empty star
                                  /// If this movie has more stars than [index+1], show a full star
                                  if (stars > index+1) {
                                    icon = Icons.star_rounded;
                                    /// Check if this movie can get half a star. If stars are more than [index] and stars is greater by 0.5, show a half star
                                  } else if (stars > index && (stars - index) >= 0.5) {
                                    icon = Icons.star_half_rounded;
                                  }
                                  return Icon(icon, size: SizeConfig.blockSizeVertical * 3);
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                '${(_movieInfo.runtime/60).floor()}h ${_movieInfo.runtime%60}mins',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ), // TODO: check this code. Could unit test it??
                              SizedBox(width: 20),
                              Text(
                                '${_movieInfo.releaseDate}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ), // TODO: show release date in nice way
                            ],
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 40,
                              child: ListView.builder( // TODO: use Row builder instead. Don't need this to scroll
                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              itemCount: _movieInfo.genres.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GenreChip(_movieInfo.genres[index].name);
                              },
                            ),
                          ),
                          HeadingText('Synopsis'),
                          Text(
                            _movieInfo.overview,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          HeadingText('User Reviews'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              UserReviewCard('title', 'body'),
                              UserReviewCard('title', 'body'),
                              // TODO: ensure that we use scroll view here and that we can have lots of reviews here
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  
  HeadingText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0,10),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}

// TODO: comment code
class GenreChip extends StatelessWidget {

  GenreChip(this.genre);
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color:Colors.white,
          ),
        ),
        child: Center(
          child: Text(
            genre,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}