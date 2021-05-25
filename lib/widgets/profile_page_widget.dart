import 'package:flutter/material.dart';

/// Utilities
import 'package:moviereviewapp/utilities/size_config.dart';

/// Widgets
import 'package:moviereviewapp/widgets/user_review_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future _future;

  fakeFuture() async {
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _future = fakeFuture();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double gridPadding = SizeConfig.blockSizeHorizontal * 3;
    print('build - TrendingPage');
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
                            Text('user_name'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.place),
                                Text('London, UK')
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
                                        Text('11'),
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
                    UserReviewCard(),
                    UserReviewCard(),
                    UserReviewCard(),
                    UserReviewCard(),
                    UserReviewCard(),
                    UserReviewCard(),
                    UserReviewCard(),
                    UserReviewCard(),
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