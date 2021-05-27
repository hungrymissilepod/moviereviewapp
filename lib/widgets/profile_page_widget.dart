import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:moviereviewapp/utilities/size_config.dart';

/// Models
import 'package:moviereviewapp/models/review_model.dart';

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

  Future _future;

  /// List of User's reviews
  List<Review> _reviews = [];

  loadData() async {
    String id = BlocProvider.of<UserCubit>(context, listen: true).state.id;
    /// Get all reviews for this user
    await getUserReviews(id);
  }

  Future getUserReviews(String id) async {
    _reviews.clear();
    _reviews.addAll(await server_util.getUserReviews(id));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = loadData();
  }

  List<Widget> getReviewCards() {
    List<Widget> widgets = [];
    for (Review r in _reviews) {
      widgets.add(UserReviewCard(r.title, r.body));
    }
    return widgets;
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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.network(
                              'https://i.imgur.com/Jvh1OQm.jpg',
                              height: 150,
                            ), // TODO: should be user image icon. should be clipped in circle
                            Text(BlocProvider.of<UserCubit>(context).state.username),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.place),
                                // Text(BlocProvider.of<UserCubit>(context).state.location),
                              ],
                            ),
                            Text('usdsi djsj sdj isdjisids sduius sudsd usdisiuiu sidusid  iss s sds skd lkseo woieoioe sj hsdjs ij iiej gjg'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('${BlocProvider.of<UserCubit>(context).state.watchlist.length}'),
                                        Icon(
                                          Icons.favorite_rounded,
                                        ),    
                                      ],
                                    ),
                                    Text('Watchlist')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('4'),
                                        Icon(
                                          Icons.star_rounded,
                                        ),    
                                      ],
                                    ),
                                    Text('Reviews')
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'My Reviews',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    Column(
                      children: getReviewCards(),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}