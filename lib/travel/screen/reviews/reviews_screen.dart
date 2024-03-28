import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/rating/rating_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/hotel_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/hotel_filter_button.dart';
import 'package:flutter_nhu_nguyen/travel/screen/reviews/components/item_review.dart';
import 'package:flutter_nhu_nguyen/travel/screen/reviews/components/item_rating.dart';
import 'package:flutter_nhu_nguyen/travel/screen/reviews/components/review_filter_button.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_appbar_item.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.hotelModel});

  final HotelModel hotelModel;

  static const String routeName = '/reviews';

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late RatingBloc _ratingBloc;
  List<RatingModel> ratings = [];
  List<RatingModel> ratingsD = [];
  double rating = 0.0;
  @override
  void initState() {
    super.initState();
    _ratingBloc = RatingBloc(RatingRepository())
      ..add(LoadRating(widget.hotelModel.id ?? ''));
  }

    void _callModalBottomSheet() async {
    Map<String, dynamic> result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => const FilterReview());

    String sortValue = result['sort'];
    bool checkComment = result['checkComment'];
    bool checkPhotos = result['checkPhotos'];
    double rates = 0;

    ratings = List.from(ratingsD);

    if (result['rating'] != null) {
      setState(() {
        rates = result['rating'];
      });
    }
    print('rates is: $rates');

    ratings.removeWhere((element) => element.rates!<rates);

    if(checkComment == true){
      ratings.removeWhere((element) => element.comment!.isEmpty);
    }
    if(checkPhotos == true){
      ratings.removeWhere((element) => element.photos?[0] == '');
    }

    // Tiếp tục xử lý dữ liệu theo cách bạn muốn
    if (sortValue != 'all') {
      sortReview(sortValue);
    }
  }

  void sortReview(String value) {
    setState(() {
      
      ratings.sort((a, b) {
        dynamic keyA, keyB;
        switch (value) {
          case 'Low to High':
            keyA = a.rates;
            keyB = b.rates;
            break;
          case 'High to Low':
            keyA = b.rates;
            keyB = a.rates;
            break;
          default:
            // Handle the default case or throw an exception
            throw ArgumentError('Invalid sorting value: $value');
        }
        return keyA.compareTo(keyB);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
        title: 'Reviews',
        // title: widget.hotelModel.hotelName ?? '',
        isIcon: true,
        filterButton: const FilterHotel(),
        showModalBottomSheet: _callModalBottomSheet,
        child: BlocBuilder<RatingBloc, RatingState>(
            bloc: _ratingBloc,
            builder: (context, state) {
              if (state is RatingLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RatingEmpty) {
                return const Center(
                  child: Column(children: [
                    SizedBox(
                      height: 24.0,
                    ),
                    // ItemConfirmRoomWidget(roomModel: widget.roomModel),
                    ItemRatingRoomWidget(rating: [0,0,0,0,0]),
                    SizedBox(
                      height: 24.0,
                    ),
                  ]),
                );
              } else if (state is RatingLoaded) {
                if(ratings.isEmpty){
                  ratings = List.from(state.ratings);
                }
                if(ratingsD.isEmpty){
                  ratingsD = List.from(state.ratings);
                }
                return Column(
                  children: [
                    // ignore: prefer_const_constructors
                    ItemRatingRoomWidget(rating: state.ratingCount),
                    Expanded(
                        child: ListView.separated(
                      // controller: scrollController,
                      itemCount: ratings.length,
                      itemBuilder: (context, i) {

                        if (i >= ratings.length) {
                          return Container(
                            margin: const EdgeInsets.only(top: 15),
                            height: 100,
                            width: 30,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return ItemReviewWidget(
                          
                          ratingModel: ratings[i],
                        );
                      },
                      separatorBuilder: (context, i) {
                        return const SizedBox();
                      },
                    ))
                  ],
                );
              }
              return const SizedBox();
            })
        );
  }
}
