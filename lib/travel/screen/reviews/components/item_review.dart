import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/get_user/get_user_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/user_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/user_repository.dart';
import 'package:readmore/readmore.dart';

class ItemReviewWidget extends StatelessWidget {
  final RatingModel ratingModel;
  ItemReviewWidget({
    Key? key,
    required this.ratingModel,
  }) : super(key: key);

  DateTime currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    late GetUserBloc userBloc;
    userBloc = GetUserBloc(UserRepository())
      ..add(LoadUserEvent(ratingModel.user ?? ''));
    DateTime storedTime = DateTime.fromMillisecondsSinceEpoch(
        ratingModel.ratedTime!.millisecondsSinceEpoch);
    Duration difference = currentTime.difference(storedTime);
    String differenceString = difference.toString();

    int seconds = difference.inSeconds.remainder(60);
    int minutes = difference.inMinutes.remainder(60);
    if (seconds >= 24) {
      differenceString = (seconds ~/ 24).toString() + ' day ago';
    }
    if (seconds < 24 && seconds > 0) {
      differenceString = (seconds).toString() + ' seconds ago';
    }
    if (seconds == 0) {
      differenceString = (minutes).toString() + ' minutes ago';
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(bottom: 24.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        BlocBuilder<GetUserBloc, GetUserState>(
                          bloc: userBloc,
                          builder: (context, state) {
                            if (state is GetUserLoaded) {
                              User user = state.user;
                              if (user.avatar != null) {
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.network(
                                    user.avatar ?? '',
                                    width: 25.14,
                              height: 40,
                                    //fit: BoxFit.fitWidth,
                                  ),
                                );
                              }
                            }
                            return Container(
                              width: 25.14,
                              height: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppPath.profile),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            BlocBuilder<GetUserBloc, GetUserState>(
                              bloc: userBloc,
                              builder: (context, state) {
                                if (state is GetUserLoaded) {
                                  User user = state.user;
                                  return Text(user.name ?? '',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold));
                                }
                                return const SizedBox();
                              },
                            ),
                            Text(differenceString,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black))
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                            children: List.generate(
                          5,
                          (index) => Icon(
                            index < ratingModel.rates!.toInt()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                        )),
                      ],
                    )
                    // Expanded(flex: 2,child: Text(ratingModel.comment??''),),
                    // Expanded(flex: 2,child: Text(ratingModel.comment??''),)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Text(ratingModel.comment ?? '',
            //     style: const TextStyle(fontSize: 14, color: Colors.black)),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color.fromARGB(255, 226, 231, 234),
              ),
              width: 400,
              constraints: const BoxConstraints(
                minHeight: 70, // Độ rộng tối thiểu
              ),
              margin: const EdgeInsets.only(bottom: 14.0),
              padding: const EdgeInsets.all(16.0),
              child: ReadMoreText(
                ratingModel.comment ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black),
                trimLength: 60,
                trimExpandedText: 'Show less',
                trimCollapsedText: 'Show more',
                moreStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                lessStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Màu của đường viền
                  width: 0.2, // Độ dày của đường viền
                  style: BorderStyle.solid,
                ),
              ),
              height: 100,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: ratingModel.photos!.length,
                itemBuilder: (context, index) {
                  if (ratingModel.photos![index] == '') {
                    return const Center(
                      child: Text('No images',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.network(
                      ratingModel.photos![index],
                      //width: 30,
                      // height: 150,
                      //fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
