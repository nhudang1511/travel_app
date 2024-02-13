import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/hotel_components.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../config/app_path.dart';
import '../../../widget/widget.dart';

class FilterHotel extends StatefulWidget {
  const FilterHotel({super.key});

  @override
  State<FilterHotel> createState() => _FilterHotelState();

}

class _FilterHotelState extends State<FilterHotel> {
  final labels = ['\$0', '\$100', '\$200', '\$300', '\$400'];
  RangeValues values = const RangeValues(0, 100);
  String sortValue = 'All';
  double rating = 0;

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
        builder: (BuildContext context,
            ScrollController
            scrollController) {
          return Container(
            padding:
            const EdgeInsets.symmetric(
                horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F2F6),
              borderRadius:
              BorderRadius.only(
                topLeft: Radius.circular(
                    16.0 * 2),
                topRight: Radius.circular(
                    16.0 * 2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  alignment:
                  Alignment.center,
                  margin:
                  const EdgeInsets.only(
                      top: 16.0),
                  child: Container(
                    height: 5,
                    width: 60,
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius
                          .circular(
                          10.0),
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Expanded(
                  child: ListView(
                    controller:
                    scrollController,
                    padding:
                    EdgeInsets.zero,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            'Choose Your Filter',
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Budget',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:
                                  Utils.modelBuilder(labels, (index, label) {
                                    const selectedColor = Colors.black;
                                    final unselectedColor = Colors.black
                                        .withOpacity(0.3);
                                    final isSelected =
                                        index >= values.start &&
                                            index <= values.end;
                                    final color = isSelected
                                        ? selectedColor
                                        : unselectedColor;
                                    return buildLabel(
                                        label: label,
                                        color: color);},
                                  ),
                                ),
                              ),
                              RangeSlider(
                                values: values,
                                min: 0,
                                max: 400,
                                divisions: 100,
                                onChanged: (values) => setState(() =>
                                    this.values = values),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Hotel Class',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0),
                            itemBuilder: (context, _) =>
                            const Icon(Icons.star,
                                color: Colors.amber),
                            onRatingUpdate: (rate) {
                              rating = rate;
                              },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ButtonFilter(
                            title: 'Facilities',
                            color: 0xFFFE9C5E,
                            image: AppPath.iconWifi,
                            onTap: () {
                              Navigator.pushNamed(
                                  context,
                                  FacilitiesScreen.routeName);
                            },
                          ),
                          ButtonFilter(
                            title: 'Property Type',
                            color: 0xFFF77777,
                            image: AppPath.iconSkyscraper,
                            onTap: () {
                              Navigator.pushNamed(
                                  context,
                                  PropertyScreen.routeName);
                            },
                          ),
                          ButtonFilter(
                            title: 'Sort By',
                            color: 0xFF3EC8BC,
                            image: AppPath.iconSort,
                            onTap: () async {
                              final result = await Navigator.pushNamed(context, SortScreen.routeName);
                              if (result != null ) {
                                sortValue = result as String;
                                print("Sort value: $sortValue");
                              }
                            },
                          ),
                          CustomButton(
                              title: 'Apply',
                              button: () {
                                final Map<String, dynamic> arguments = {'sort': sortValue, 'rating': rating};
                                Navigator.pop(context, arguments);
                                  }),
                          Container(
                            width: MediaQuery
                                .of(
                                context)
                                .size
                                .width,
                            margin:
                            const EdgeInsets
                                .only(
                                bottom:
                                20),
                            decoration:
                            ShapeDecoration(
                              gradient:
                              LinearGradient(
                                begin: const Alignment(
                                    0.71,
                                    -0.71),
                                end: const Alignment(
                                    -0.71,
                                    0.71),
                                colors: [
                                  const Color(
                                      0xFF8862E4)
                                      .withOpacity(
                                      0.10),
                                  const Color(
                                      0xFF6657CF)
                                      .withOpacity(
                                      0.10)
                                ],
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    25),
                              ),
                            ),
                            child: CustomButton2(title: 'Reset', onTap: () {},),
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