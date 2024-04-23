import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/components/sort/facilities_flight_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/components/sort/sort_flight.dart';

import '../../../../../config/app_path.dart';
import '../../../../widget/widget.dart';

class FilterFlight extends StatefulWidget {
  const FilterFlight({super.key});

  @override
  State<FilterFlight> createState() => _FilterFlightState();
}

class _FilterFlightState extends State<FilterFlight> {
  final labels = ['\$0', '\$200', '\$400', '\$600', '\$800'];
  RangeValues values = const RangeValues(0, 200);

  final labelsTransit = ['0d', '3d', '6d', '9d', '12d'];
  RangeValues valuesTransit = const RangeValues(0, 3);
  num budgetStart = 0;
  num budgetEnd = 0;
  num transitStart = 0;
  num transitEnd = 0;
  List<String> facilities = [];
  String sortValue = 'All';

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
                          Text(
                            'Transit',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Transit Duration',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: Utils.modelBuilder(
                                    labelsTransit,
                                    (index, label) {
                                      const selectedColor = Colors.black;
                                      final unselectedColor =
                                          Colors.black.withOpacity(0.3);
                                      final isSelected =
                                          index >= valuesTransit.start &&
                                              index <= valuesTransit.end;
                                      final color = isSelected
                                          ? selectedColor
                                          : unselectedColor;
                                      return buildLabel(
                                          label: label, color: color);
                                    },
                                  ),
                                ),
                              ),
                              RangeSlider(
                                values: valuesTransit,
                                min: 0,
                                max: 12,
                                divisions: 4,
                                onChanged: (values) => setState(() {
                                  valuesTransit = values;
                                  transitStart = values.start;
                                  transitEnd = values.end;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Budget',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: Utils.modelBuilder(
                                    labels,
                                    (index, label) {
                                      const selectedColor = Colors.black;
                                      final unselectedColor =
                                          Colors.black.withOpacity(0.3);
                                      final isSelected =
                                          index >= values.start &&
                                              index <= values.end;
                                      final color = isSelected
                                          ? selectedColor
                                          : unselectedColor;
                                      return buildLabel(
                                          label: label, color: color);
                                    },
                                  ),
                                ),
                              ),
                              RangeSlider(
                                values: values,
                                min: 0,
                                max: 1000,
                                divisions: 6,
                                onChanged: (values) => setState(() {
                                  this.values = values;
                                  budgetStart = values.start;
                                  budgetEnd = values.end;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ButtonFilter(
                            title: 'Facilities',
                            color: 0xFFFE9C5E,
                            image: AppPath.iconWifi,
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                  context, FacilitiesFlightScreen.routeName);
                              if(result != null){
                                facilities = result as List<String>;
                              }
                            },
                          ),
                          ButtonFilter(
                            title: 'Sort By',
                            color: 0xFF3EC8BC,
                            image: AppPath.iconSort,
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                  context, SortFlightScreen.routeName);
                              if(result != null){
                                sortValue = result as String;
                              }
                            },
                          ),
                          CustomButton(title: 'Apply', button: () {
                            final Map<String, dynamic> arguments = {
                              'sort': sortValue,
                              'budgetStart': budgetStart,
                              'budgetEnd': budgetEnd,
                              'facilities': facilities,
                              'transitStart': transitStart,
                              'transitEnd': transitEnd
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
                              onTap: () {},
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
