import 'package:flutter/material.dart';

/// Bloc + Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviereviewapp/cubit/user_cubit.dart';

/// Utilities
import 'package:moviereviewapp/utilities/server_util.dart' as server_util;
import 'package:moviereviewapp/utilities/ui_constants.dart';
import 'package:moviereviewapp/utilities/size_config.dart';

/// Widgets
import 'package:moviereviewapp/widgets/common_widget.dart';

/// Models
import 'package:moviereviewapp/models/review_model.dart';
import 'package:moviereviewapp/models/user_model.dart';

class UserReviewCard extends StatefulWidget {

  UserReviewCard(this.review, this.userId, this.onDeleteCallback);

  final Review review;
  final String userId;
  final Function onDeleteCallback;

  @override
  _UserReviewCardState createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {

  Future _future;
  
  /// The user that wrote this review
  User _reviewUser;

  Future<User> getReviewUser() async {
    return _reviewUser = await server_util.getUser(widget.review.userId);
  }

  @override
  void initState() {
    super.initState();
    _future = getReviewUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String username = _reviewUser.id == state.user.id ? '${_reviewUser.username} (You)' : '${_reviewUser.username}';
                return Container(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          /// Username and avatar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: SizeConfig.blockSizeVertical * 2,
                                    width: SizeConfig.blockSizeVertical * 2,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(kAccentColour)),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: Image.network(_reviewUser.imageUrl).image,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 0.6),
                                  Text(
                                    username,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              StarRow(widget.review.rating.toDouble()),
                            ],
                          ),
                          /// Review body and delete button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 0.6),
                                    Text(
                                      widget.review.title,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 0.6),
                                    Text(
                                      widget.review.body,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                               widget.review.userId == widget.userId ?
                              IconButton(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: () { widget.onDeleteCallback(widget.review.id); },
                              ) : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              /// Show empty Card while loading
              return Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}