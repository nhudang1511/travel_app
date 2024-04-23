import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/booking_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/write_review/write_review_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../model/hotel_model.dart';
import '../../model/room_model.dart';
import '../../repository/hotel_repository.dart';
import '../../repository/room_repository.dart';
import '../../widget/widget.dart';
import '../main_screen.dart';

class BriefcaseScreen extends StatefulWidget {
  const BriefcaseScreen({super.key});

  @override
  State<BriefcaseScreen> createState() => _BriefcaseScreenState();
}

class _BriefcaseScreenState extends State<BriefcaseScreen> {
  late BookingBloc _bookingBloc;
  List<BookingModel> bookings = [];
  late HotelModel hotelList;
  late RoomModel room;
  final dateFormatter = DateFormat('dd MMM yyyy');
  String? email;
  late HotelBloc _hotelBloc;
  late RoomBloc _roomBloc;

  @override
  void initState() {
    super.initState();
    _bookingBloc = BookingBloc(BookingRepository())..add(LoadBooking());
    _hotelBloc = HotelBloc(HotelRepository(RoomRepository()))
      ..add(LoadHotels());
    _roomBloc = RoomBloc(RoomRepository())..add(LoadRoom());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _bookingBloc),
        BlocProvider(create: (_) => _hotelBloc),
        BlocProvider(create: (_) => _roomBloc)
      ],
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppBar(
            titlePage: 'Briefcase',
            subTitlePage: '',
            isFirst: true,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  email = state.user.email;
                }
                return BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    if (state is BookingLoaded) {
                      bookings = state.bookingModel
                          .where((element) => element.email == email)
                          .toList();
                    }
                    return MasonryGridView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: bookings.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1),
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, BookingItem.routeName,
                                      arguments: bookings[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 24.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: const Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Icon(Icons.home_filled, size: 25),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                                bookings[index].createdAt !=
                                                        null
                                                    ? 'Booking ${bookings[index].createdAt?.toDate()}'
                                                    : 'Booking',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                        color: Colors.black)),
                                          ),
                                          BlocBuilder<HotelBloc, HotelState>(
                                            builder: (context, state) {
                                              if (state is HotelLoaded) {
                                                hotelList = state.hotels
                                                    .where((element) =>
                                                        element.id ==
                                                        bookings[index].hotel)
                                                    .first;

                                                    return Container(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: Text(
                                                    bookings[index].hotel !=
                                                            null
                                                        ? 'Hotel:\n${hotelList.hotelName}'
                                                        : 'Hotel: null',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black)),
                                              );
                                              }
                                               return const SizedBox(); 
                                            }
                                          ),
                                          BlocBuilder<RoomBloc, RoomState>(
                                            builder: (context, state) {
                                              if (state is RoomLoaded) {
                                                room = state.rooms
                                                    .where((element) =>
                                                        element.id ==
                                                        bookings[index].room)
                                                    .first;
                                                    return Container(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: Text(
                                                    bookings[index].room != null
                                                        ? 'Room: ${room.name}'
                                                        : 'Room: null',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black)),
                                              );
                                              }
                                              
                                               return const SizedBox();
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                );
              },
            ),
          )),
    );
  }
}

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
                            return CustomButton(
                                title: 'Write Review',
                                button: () {
                                    Navigator.of(context).pushNamed(
                                        WriteReviewScreen.routeName,
                                        arguments: hotelModel);
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
