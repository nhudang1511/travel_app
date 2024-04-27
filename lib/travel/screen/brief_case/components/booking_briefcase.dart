import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../bloc/bloc.dart';
import '../../../model/booking_model.dart';
import '../../../model/hotel_model.dart';
import '../../../model/room_model.dart';
import '../../../repository/repository.dart';
import 'booking_item.dart';

class BookingBriefcase extends StatefulWidget {
  const BookingBriefcase({super.key});

  @override
  State<BookingBriefcase> createState() => _BookingBriefcaseState();
}

class _BookingBriefcaseState extends State<BookingBriefcase> {
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
      child: SizedBox(
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
                          horizontal: 13),
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
      )
    );
  }
}
