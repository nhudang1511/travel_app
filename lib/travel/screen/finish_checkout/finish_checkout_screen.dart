import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/hotel_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/hotel_repository.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../repository/room_repository.dart';
import '../main_screen.dart';

class FinishCheckoutScreen extends StatefulWidget {
  const FinishCheckoutScreen({super.key});

  static const String routeName = '/finish_checkout';

  @override
  State<FinishCheckoutScreen> createState() => _FinishCheckoutScreenState();
}

class _FinishCheckoutScreenState extends State<FinishCheckoutScreen> {
  BookingModel? bookingModel;
  String? hotelName;
  String? roomName;
  final dateFormatter = DateFormat('dd MMM yyyy');
  int? daysDifference;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoadedById) {
          bookingModel = state.bookingModel;
          //print(bookingModel?.id);
          if (bookingModel?.dateStart != null &&
              bookingModel?.dateEnd != null) {
            // Duration? duration = bookingModel?.dateEnd
            //     ?.difference(bookingModel?.dateStart ?? DateTime.now());
            // daysDifference = duration?.inDays;
          }
        }
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff8F67E8), Color(0xff6357CC)],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
            child: CouponCard(
              curveAxis: Axis.horizontal,
              backgroundColor: Colors.white,
              height: MediaQuery.of(context).size.height - 20,
              firstChild: Center(
                child: Text(
                  'Completing\n booking hotels',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              secondChild: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    border: DashedBorder(
                  dashLength: 15,
                  top: BorderSide(color: Color(0xFFE5E5E5)),
                )),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (context) =>
                              HotelBloc(HotelRepository(RoomRepository()))
                                ..add(LoadHotels())),
                      BlocProvider(
                          create: (context) =>
                              RoomBloc(RoomRepository())..add(LoadRoom()))
                    ],
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Details Booking',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<HotelBloc, HotelState>(
                                builder: (context, state) {
                                  if (state is HotelLoaded) {
                                    List<HotelModel> hotels = state.hotels
                                        .where((element) =>
                                            element.id == bookingModel?.hotel)
                                        .toList();
                                    hotelName = hotels.first.hotelName ?? 'null';
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                  return Text(
                                    'Hotel: $hotelName',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.black),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              BlocBuilder<RoomBloc, RoomState>(
                                builder: (context, state) {
                                  if (state is RoomLoaded) {
                                    List<RoomModel> rooms = state.rooms
                                        .where((element) =>
                                            element.id == bookingModel?.room)
                                        .toList();
                                    roomName = rooms.first.name ?? 'null';
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                  return Text(
                                    'Room: $roomName',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.black),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              // Text(
                              //   'Date: $daysDifference (from: ${dateFormatter.format(bookingModel!.dateStart ?? DateTime.now())} - to ${dateFormatter.format(bookingModel!.dateEnd ?? DateTime.now())})',
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .headlineSmall
                              //       ?.copyWith(color: Colors.black),
                              // ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Email: ${bookingModel?.email}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          CustomButton(
                              title: 'Home',
                              button: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    MainScreen.routeName, (route) => false);
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
