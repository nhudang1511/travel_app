import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/repository/flight_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/components/sort/filter_flight.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import '../../../../config/app_path.dart';
import '../../../model/filght_model.dart';
import '../../../widget/widget.dart';
import 'package:coupon_uikit/coupon_uikit.dart';

import '../../screen.dart';

class ResultFlightScreen extends StatefulWidget {
  const ResultFlightScreen(
      {super.key,
      required this.fromPlace,
      required this.toPlace,
      required this.selectedTime,
      required this.passengers});

  static const String routeName = '/result_flight';
  final String? fromPlace;
  final String? toPlace;
  final DateTime? selectedTime;
  final int? passengers;

  @override
  State<ResultFlightScreen> createState() => _ResultFlightScreenState();
}

class _ResultFlightScreenState extends State<ResultFlightScreen> {
  FlightBloc flightBloc = FlightBloc(FlightRepository());
  List<FlightModel> flights = [];

  @override
  void initState() {
    super.initState();
    flightBloc.add(LoadFlightByDes(
        from: widget.fromPlace ?? '',
        to: widget.toPlace ?? '',
        selectedDate: widget.selectedTime ?? DateTime.now(),
        passengers: widget.passengers ?? 0));
    //scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    flightBloc.close();
    //scrollController.dispose();
    super.dispose();
  }

  void _callModalBottomSheet() async {
    Map<String, dynamic> result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const FilterFlight());
    flightBloc.add(SortFlightBy(
        sort: result['sort'],
        start: result['budgetStart'],
        end: result['budgetEnd'],
        services: result['facilities'],
        transStart: result['transitStart'],
        transEnd: result['transitEnd']));
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
        title: '${widget.fromPlace} - \u{2708} - ${widget.toPlace}',
        isIcon: true,
        filterButton: const FilterFlight(),
        showModalBottomSheet: _callModalBottomSheet,
        child: BlocBuilder<FlightBloc, FlightState>(
          bloc: flightBloc,
          builder: (context, state) {
            if (state is FlightLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FlightFailure) {
              return Center(
                child: Text(
                  'No Posts',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              );
            } else if (state is FlightLoaded) {
              flights = state.flights;
              return ListView.separated(
                itemCount: flights.length,
                itemBuilder: (context, i) {
                  return ItemTicket(flightModel: flights[i]);
                },
                separatorBuilder: (context, i) {
                  return const SizedBox();
                },
              );
            }
            return const SizedBox();
          },
        ));
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
