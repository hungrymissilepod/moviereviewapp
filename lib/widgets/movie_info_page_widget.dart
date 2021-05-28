import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:moviereviewapp/utilities/size_config.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';
import 'package:uuid/uuid.dart';

/// Models
import 'package:moviereviewapp/models/review_model.dart';
import 'package:moviereviewapp/models/movie_info_model.dart';

/// Widgets
import 'package:moviereviewapp/widgets/user_review_widget.dart';
import 'package:moviereviewapp/widgets/common_widget.dart';

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

  /// Movie information for this movie
  MovieInfo _movieInfo;

  /// User reviews for this movie
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    /// Get movie information and reviews for this movie
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
  
  /// Delete user review
  _deleteReview(String id) async {
    await server_util.deleteReview(id);
    setState(() {
      _reviews.removeWhere((e) => e.id == id);
    });
  }

  /// Add or remove movie to watchlist
  _tapFavouriteButton(UserLoaded state) async {
    setState(() {
      BlocProvider.of<UserCubit>(context).toggleMovieInWatchlist(state.user, _movieInfo.id);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: SafeArea(
        top: false,
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              return FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    /// Check if user has 'liked' this movie. Is it in user's watchlist
                    bool liked = state.user.watchlist.contains(_movieInfo.id);
                    return Scaffold(
                      body: Column(
                        children: [
                          MovieImageHeader(_movieInfo, liked, _tapFavouriteButton, state),
                          MovieInfoBody(_movieInfo, state, _reviews, _deleteReview),
                        ],
                      ),
                      /// FloatingActionButton for writing a user revieww
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.rate_review_rounded),
                        onPressed: () {
                          showDialog(context: context, builder: (BuildContext context) => WriteReviewDialog(state.user.id, _movieInfo.id));
                        },
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

/// Image at top of movie info page
class MovieImageHeader extends StatelessWidget {

  MovieImageHeader(this.movieInfo, this.liked, this.onTap, this.state);
  final MovieInfo movieInfo;
  final bool liked;
  final Function onTap;
  final UserState state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 26,
          child: Image.network(
            'https://image.tmdb.org/t/p/original/${movieInfo.backdropUri}',
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
                    movieInfo.title,
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
            onTap: () { onTap(state); },
            child: Icon(
              liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class MovieInfoBody extends StatelessWidget {

  MovieInfoBody(this.movieInfo, this.state, this.reviews, this.onDeleteReview);

  final MovieInfo movieInfo;
  final UserLoaded state;
  final List<Review> reviews;
  final Function onDeleteReview;

  List<Widget> getReviewCards(String id) {
    List<Widget> widgets = [];
    for (Review r in reviews) {
      widgets.add(UserReviewCard(r, id, onDeleteReview));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${movieInfo.voteAverage}', style: TextStyle(color: Color(kAccentColour), fontSize: 24)),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 1),
                StarRow(movieInfo.voteAverage, showHalfStars: true),
              ],
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 1),
            Row(
              children: [
                Text(
                  '${(movieInfo.runtime/60).floor()}h ${movieInfo.runtime%60}mins',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                Text(
                  '${movieInfo.releaseDate}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 5,
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                scrollDirection: Axis.horizontal,
                itemCount: movieInfo.genres.length,
                itemBuilder: (BuildContext context, int index) {
                  return GenreChip(movieInfo.genres[index].name);
                },
              ),
            ),
            HeadingText('Synopsis'),
            Text(movieInfo.overview, style: TextStyle(color: Colors.white, fontSize: 14)),
            HeadingText('User Reviews'),
            Column(children: getReviewCards(state.user.id)),
          ],
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
      padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 3, 0, SizeConfig.blockSizeVertical * 1),
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

/// Chip to show movie genres
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
  
  WriteReviewDialog(this.userId, this.movieId);
  final String userId;
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
    String id = Uuid().v4();
    Review r = Review(id: id, userId: widget.userId, movieId: widget.movieId, title: _title, body: _body, rating: _rating * 2); /// multiply by 2 because we have 5 stars but rating should be out of 10

    /// Catch errors when trying to post review
    try {
      await server_util.postReview(r);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submitting Review')));
      _closeForm();
    } catch(e) {
      setState(() { _error = 'An error occured. Please try again.'; });
    }
  }

  _closeForm() {
    Navigator.of(context).pop();
  }

  /// Text widget to display error messges
  Widget showAlert() {
    if (_error != null) {
      return Column(
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * 1),
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
                key: ValueKey('titleTextFormField'),
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) { _title = value; },
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Please enter a title'; }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              TextFormField(
                key: ValueKey('bodyTextFormField'),
                decoration: InputDecoration(labelText: 'Body'),
                onChanged: (value) { _body = value; },
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Please enter body text'; }
                  else if (value.length < 10) { return 'Must have more than 10 characters'; } // TODO: could do widget testing with this form
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 4),
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
          onPressed: () { _closeForm(); },
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