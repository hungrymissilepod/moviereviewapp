import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:moviereviewapp/utilities/size_config.dart';

/// Models
import 'package:moviereviewapp/models/review_model.dart';
import 'package:moviereviewapp/utilities/ui_constants.dart';

/// Widgets
import 'package:moviereviewapp/widgets/user_review_widget.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  /// List of User's reviews
  List<Review> _reviews = [];

  Future getUserReviews(String id) async {
    _reviews.clear();
    _reviews.addAll(await server_util.getUserReviews(id));
  }
  
  _deleteReview(String id) async {
    await server_util.deleteReview(id);
    setState(() {
      _reviews.removeWhere((e) => e.id == id);
    });
  }

  List<Widget> getReviewCards(String id) {
    List<Widget> widgets = [];
    for (Review r in _reviews) {
      widgets.add(UserReviewCard(r, id, _deleteReview));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double gridPadding = SizeConfig.blockSizeHorizontal * 3;
    return SafeArea(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return FutureBuilder(
              future: getUserReviews(state.user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: gridPadding),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(kAccentColour), width: 2),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: Image.network(state.user.imageUrl).image,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(state.user.username),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.place),
                                      Text(state.user.location),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(state.user.bio, textAlign: TextAlign.center),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      UserInfoColumn(state.user.watchlist.length, 'Watchlist', Icon(Icons.favorite_rounded)),
                                      UserInfoColumn(_reviews.length, 'Reviews', Icon(Icons.star_rounded)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                            child: Text(
                              'My Reviews',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Column(children: getReviewCards(state.user.id)),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          } else {
            return Container(child: Text('not loaded'));
          }
        }
      ),
    );
  }
}

/// Used for showing Watchlist and Reviews in user profile
class UserInfoColumn extends StatelessWidget {

  UserInfoColumn(this.count, this.label, this.icon);
  
  final int count;
  final String label;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('$count', style: TextStyle(fontSize: 16)),
            icon,
          ],
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}