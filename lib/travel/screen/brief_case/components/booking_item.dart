import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../../bloc/bloc.dart';
import '../../../model/booking_model.dart';
import '../../../model/hotel_model.dart';
import '../../../model/room_model.dart';
import '../../../repository/repository.dart';
import '../../../widget/custom_button.dart';
import '../../main_screen.dart';
import '../../write_review/write_review_screen.dart';

class BookingItem extends StatefulWidget {
  const BookingItem({super.key, required this.booking});

  static const String routeName = '/item_booking';

  @override
  State<BookingItem> createState() => _BookingItemState();
  final BookingModel booking;
}

class _BookingItemState extends State<BookingItem> {
  String? hotelName;
  HotelModel? hotelModel;
  String? roomName;
  final dateFormatter = DateFormat('dd MMM yyyy');
  int? daysDifference;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                              element.id == widget.booking.hotel)
                                  .toList();
                              hotelName = hotels.first.hotelName ?? 'null';
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
                              element.id == widget.booking.room)
                                  .toList();
                              roomName = rooms.first.name ?? 'null';
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
                        Text(
                          'Email: ${widget.booking.email}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        BlocBuilder<HotelBloc, HotelState>(
                          builder: (context, state) {
                            if (state is HotelLoaded) {
                              List<HotelModel> hotels = state.hotels
                                  .where((element) =>
                              element.id == widget.booking.hotel)
                                  .toList();
                              hotelModel = hotels.first;
                            }
                            if(widget.booking.review != ""){
                              return CustomButton(
                                  title: 'Reviewed',
                                  button: () {
                                    // Navigator.of(context).pushNamed(
                                    //     WriteReviewScreen.routeName,
                                    //     arguments: hotelModel);
                                  });
                            }
                            return CustomButton(
                                title: 'Write Review',
                                button: () {
                                  Navigator.of(context).pushNamed(
                                      WriteReviewScreen.routeName,
                                      arguments: {'hotelModel': hotelModel,'booking': widget.booking.id});
                                });
                          },
                        ),
                        CustomButton(
                            title: 'Home',
                            button: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  MainScreen.routeName, (route) => false);
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}