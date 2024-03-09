import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/repository/flight_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/check_out_screen_flight.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import '../../../../config/app_path.dart';
import '../../../model/filght_model.dart';
import '../../../widget/widget.dart';
import 'package:coupon_uikit/coupon_uikit.dart';

import '../../screen.dart';

class ResultFlightScreen extends StatefulWidget {
  const ResultFlightScreen(
      {super.key, required this.fromPlace, required this.toPlace});

  static const String routeName = '/result_flight';
  final String fromPlace;
  final String toPlace;

  @override
  State<ResultFlightScreen> createState() => _ResultFlightScreenState();
}

class _ResultFlightScreenState extends State<ResultFlightScreen> {
  FlightBloc flightBloc = FlightBloc();
  List<FlightModel> flights = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // if (widget.fromPlace == "All" || widget.toPlace == "All") {
    //   _flightBloc = FlightBloc(FlightRepository())..add(LoadFlight());
    // } else {
    //   _flightBloc = FlightBloc(FlightRepository())
    //     ..add(SearchFlight(
    //       fromPlace: widget.fromPlace,
    //       toPlace: widget.toPlace,
    //     ));
    // }
    flightBloc.add(FlightEventStart());
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // print('scroll');
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      flightBloc.add(FlightEventFetchMore());
    }
  }

  @override
  void dispose() {
    flightBloc.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
      title: '${widget.fromPlace} - \u{2708} - ${widget.toPlace}',
      isIcon: true,
      filterButton: const FilterFlight(),
      showModalBottomSheet: () {},
      child:  BlocBuilder<FlightBloc, FlightState>(
        bloc: flightBloc,
        builder: (context, state) {
          if (state is FlightStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FlightStateEmpty) {
            return Center(
              child: Text(
                'No Posts',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            );
          } else if (state is FlightStateLoadSuccess) {
            return ListView.separated(
              controller: scrollController,
              itemCount: state.hasMoreFlight ? state.flight.length + 1 : state.flight.length,
              itemBuilder: (context, i) {
                if (i >= state.flight.length) {
                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 100,
                    width: 30,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return ItemTicket(flightModel: state.flight[i]);
              },
              separatorBuilder: (context, i) {
                return const SizedBox();
              },
            );
          }
          return const SizedBox();
        },
      )
    );
  }
}

class ItemTicket extends StatefulWidget {
  const ItemTicket({super.key, required this.flightModel});

  final FlightModel flightModel;

  @override
  State<ItemTicket> createState() => _ItemTicketState();
}

class _ItemTicketState extends State<ItemTicket> {
  final dateFormatter = DateFormat('dd MMM yyyy');

  final Map<String, String> iconAir = {
    'AirAsia': AppPath.iconAsia,
    'LionAir': AppPath.iconLion,
    'BatikAir': AppPath.iconBatik,
    'Garuna': AppPath.iconGaruna,
    'Citilink': AppPath.iconCitilink,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(CheckOutStepFlight.routeName,
            arguments: {'step': 0, 'flight': widget.flightModel});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: CouponCard(
          height: 150,
          backgroundColor: Colors.white,
          curveAxis: Axis.vertical,
          curveRadius: 30,
          firstChild: Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Image.asset(
                    iconAir[widget.flightModel.airline] ?? AppPath.iconAsia,
                    fit: BoxFit.contain,
                    height: 75,
                    width: 75,
                  ),
                ],
              )),
          secondChild: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              border: DashedBorder(
                dashLength: 15,
                left: BorderSide(color: Color(0xFFE5E5E5)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemDetailTicket(
                      title: 'Departure',
                      content: dateFormatter.format(
                          widget.flightModel.departure_time ?? DateTime.now()),
                    ),
                    ItemDetailTicket(
                      title: 'Arrive',
                      content: dateFormatter.format(
                          widget.flightModel.arrive_time ?? DateTime.now()),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemDetailTicket(
                      title: 'Flight No.',
                      content: '${widget.flightModel.no}',
                    ),
                    Text(
                      '${widget.flightModel.price}',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemDetailTicket extends StatelessWidget {
  const ItemDetailTicket({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0xFF636363)),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}

class FilterFlight extends StatefulWidget {
  const FilterFlight({super.key});

  @override
  State<FilterFlight> createState() => _FilterFlightState();
}

class _FilterFlightState extends State<FilterFlight> {
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
                          const SizedBox(
                            height: 16,
                          ),
                          ButtonFilter(
                            title: 'Facilities',
                            color: 0xFFFE9C5E,
                            image: AppPath.iconWifi,
                            onTap: () {
                              Navigator.pushNamed(context, '/facilities');
                            },
                          ),
                          ButtonFilter(
                            title: 'Sort By',
                            color: 0xFF3EC8BC,
                            image: AppPath.iconSort,
                            onTap: () {
                              Navigator.pushNamed(context, '/sort');
                            },
                          ),
                          CustomButton(title: 'Apply', button: () {}),
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
