import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/facilities_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/property_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/sort_screen.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_appbar_item.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button2.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FilterReview extends StatefulWidget {
  const FilterReview({super.key});

  @override
  State<FilterReview> createState() => _FilterReviewState();
}

class _FilterReviewState extends State<FilterReview> {
  double rating = 1;

  bool checkComment = false;
  bool checkPhotos = false;
  String sort = 'all';
  Widget buildLabel({
    required String label,
    required Color color,
  }) =>
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ).copyWith(color: color),
      );
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F2F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0 * 2),
                topRight: Radius.circular(16.0 * 2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    height: 5,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Filter',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                TextSpan(
                                  text: 'Rating',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '     -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ])),
                          const SizedBox(
                            height: 16,
                          ),
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rate) {
                              rating = rate;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                TextSpan(
                                  text: 'Type',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '       -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ])),
                          const SizedBox(
                            height: 16,
                          ),
                          CheckboxListTile(
                            title: const Text('With Comment'),
                            controlAffinity: ListTileControlAffinity.platform,
                            value: checkComment,
                            activeColor: const Color(0xFF8862E4),
                            onChanged: ((bool? value) {
                              setState(() {
                                checkComment = value ?? false;
                              });
                            }),
                          ),
                          CheckboxListTile(
                            title: const Text('With Photos'),
                            controlAffinity: ListTileControlAffinity.platform,
                            value: checkPhotos,
                            activeColor: const Color(0xFF8862E4),
                            onChanged: ((bool? value) {
                              setState(() {
                                checkPhotos = value ?? false;
                              });
                            }),
                          ),
                          // ButtonFilter(
                          //   title: 'Sort By Review',
                          //   color: 0xFF3EC8BC,
                          //   image: AppPath.iconSort,
                          //   onTap: () async {
                          //     final result = await Navigator.pushNamed(
                          //         context, SortScreen.routeName);
                          //     if (result != null) {
                          //       sortValue = result as String;
                          //       print("Sort value: $sortValue");
                          //     }
                          //   },
                          // ),

                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                TextSpan(
                                  text: 'Sort By',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '    -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ])),
                          RadioListTile(
                            title: const Text('High to Low Score'),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: 'High to Low',
                            groupValue: sort,
                            activeColor: const Color(0xFF8862E4),
                            onChanged: (value) {
                              setState(() {
                                sort = value!;
                              });
                            },
                          ),

                          RadioListTile(
                            title: const Text('Low to High Score'),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: 'Low to High',
                            groupValue: sort,
                            activeColor: const Color(0xFF8862E4),
                            onChanged: (value) {
                              setState(() {
                                sort = value!;
                              });
                            },
                          ),

                          CustomButton(
                              title: 'Apply',
                              button: () {
                                final Map<String, dynamic> arguments = {
                                  'sort': sort,
                                  'checkComment': checkComment,
                                  'checkPhotos': checkPhotos,
                                  'rating': rating
                                };
                                Navigator.pop(context, arguments);
                              }),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.71, -0.71),
                                end: const Alignment(-0.71, 0.71),
                                colors: [
                                  const Color(0xFF8862E4).withOpacity(0.10),
                                  const Color(0xFF6657CF).withOpacity(0.10)
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: CustomButton2(
                              title: 'Reset',
                              onTap: () {
                                setState(() {
                                  // rating = 5;
                                  sort = 'all';
                                  checkComment = false;
                                  checkPhotos = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
