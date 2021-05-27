import 'package:flutter/material.dart';
import 'package:moviereviewapp/models/review_model.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:moviereviewapp/utilities/size_config.dart';

/// Models
import 'package:moviereviewapp/models/movie_info_model.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Widgets
import 'package:moviereviewapp/widgets/user_review_widget.dart';

/// Bloc + Cubit
import 'package:moviereviewapp/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieInfoPage extends StatefulWidget {
  
  MovieInfoPage({ Key key, @required this.id }) : super(key: key);

  final int id;

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {

  Future _future;
  MovieInfo _movieInfo;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _future = getMovieInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Load MovieInfo for this movie
  Future getMovieInfo() async {
    _movieInfo = await server_util.getMovieInfo(widget.id);
    _reviews = await server_util.getReviewsForMovie(widget.id);
    return _movieInfo;
  }

  List<Widget> getReviewCards() {
    List<Widget> widgets = [];
    for (Review r in _reviews) {
      widgets.add(UserReviewCard(r.title, r.body));
    }
    return widgets;
  }

  /// Add or remove movie to watchlist
  _tapFavouriteButton() async {
    List<int> watchlist = BlocProvider.of<UserCubit>(context).state.watchlist;
    await server_util.addRemoveToWatchlist(watchlist, _movieInfo.id);
    setState(() {
      BlocProvider.of<UserCubit>(context).addRemoveToWatchlist(_movieInfo.id);
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
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    print('review movie');
                    showDialog(context: context, builder: (BuildContext context) => WriteReviewDialog(_movieInfo.id));
                  },
                  child: Icon(Icons.rate_review_rounded, color: Colors.black),
                ),
                body: Column(
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
                              children: getReviewCards(),
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.stretch,
                            //   children: [
                            //     UserReviewCard('title', 'body'),
                            //     UserReviewCard('title', 'body'),
                            //     // TODO: ensure that we use scroll view here and that we can have lots of reviews here
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

class WriteReviewDialog extends StatefulWidget {
  
  WriteReviewDialog(this.movieId);
  final int movieId;

  @override
  _WriteReviewDialogState createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  
  final _formKey = GlobalKey<FormState>();  
  double _rating = 0;
  String _title, _body, _error = '';

  _submitForm() async {
    setState(() { _error = null; });

    /// If form fails to validate
    if (!_formKey.currentState.validate()) {
      if (_rating == 0) {
        setState(() { _error = 'Please leave a rating'; });
      }
      return;
    }

    /// Post review to database
    Review r = Review(userId: BlocProvider.of<UserCubit>(context).state.id, movieId: widget.movieId, title: _title, body: _body, rating: _rating.toInt());
    await server_util.postReview(r);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submitting Review')));
  }

  Widget showAlert() {
    if (_error != null) {
      return Column(
        children: [
          SizedBox(height:10),
          Text(_error, style: TextStyle(color: Color(kAccentColour), fontSize: 13)),
        ],
      );
    }
    return SizedBox(height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Leave a review'),
      content: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) { _title = value; },
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Please enter a title'; }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Body'),
                onChanged: (value) { _body = value; },
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Please enter body text'; }
                  else if (value.length < 10) { return 'Must have more than 10 characters'; } // TODO: could do widget testing with this form
                  return null;
                },
              ),
              SizedBox(height: 40),
              StarRating(
                rating: _rating,
                onRatingChanged: (rating) => setState(() => _rating = rating),
              ),
              showAlert(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () { Navigator.of(context).pop(); },
        ),
        TextButton(
          child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () { _submitForm(); },
        ),
      ],
    );
  }
}


/// Found on StackOverflow: https://stackoverflow.com/questions/46637566/how-to-create-rating-star-bar-properly
typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border_rounded,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half_rounded,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star_rounded,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)), mainAxisAlignment: MainAxisAlignment.center);
  }
}