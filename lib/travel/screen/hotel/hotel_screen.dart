import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/detail_hotel/detail_hotel_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/hotel_filter_button.dart';
import '../../../config/shared_preferences.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/hotel/hotel_bloc.dart';
import '../../bloc/room/room_bloc.dart';
import '../../model/hotel_model.dart';
import '../../widget/custom_appbar_item.dart';
import '../../widget/dashline.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen(
      {super.key,
      required this.maxGuest,
      required this.maxRoom,
      required this.destination});

  static const String routeName = '/hotel';
  final int maxGuest;
  final int maxRoom;
  final String destination;

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  late HotelBloc hotelBloc;
  List<HotelModel> hotels = [];
  num rating = 0.0;
  List<HotelModel> hotelLiked = [];
  List<String> hotelList = SharedService.getLikedHotels();
  late BookingBloc _bookingBloc;
  late RoomBloc _roomBloc;

  @override
  void initState() {
    super.initState();
    hotelBloc = HotelBloc(HotelRepository(RoomRepository()))
      ..add(LoadHotelByBooking(
          widget.maxGuest, widget.maxRoom, widget.destination));
    if (hotelList.isNotEmpty) {
      hotelLiked = hotelList
          .map((e) => HotelModel().fromDocument(json.decode(e)))
          .toList();
    }
    _bookingBloc = BookingBloc(BookingRepository())..add(GetBookingByLessDay());
    _roomBloc = RoomBloc(RoomRepository())..add(LoadRoom());
  }

  @override
  void dispose() {
    hotelBloc.close();
    _bookingBloc.close();
    _roomBloc.close();
    super.dispose();
  }

  void _callModalBottomSheet() async {
    Map<String, dynamic> result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const FilterHotel());
    hotelBloc.add(SortHotelBy(
        sort: result['sort'],
        rate: result['rating'],
        start: result['budgetStart'],
        end: result['budgetEnd'],
        services: result['facilities'],
        property: result['property']));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _bookingBloc,
        ),
        BlocProvider(
          create: (context) => _roomBloc,
        )
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              print(state);
              if (state is BookingLoaded) {
                List<BookingModel> booking = state.bookingModel;
                print(booking.length);
                if (booking.isNotEmpty) {
                  for (BookingModel bookItem in booking) {
                    // hotelBloc.add(AddInHotel(bookItem.hotel ?? '',
                    //     bookItem.numberGuest ?? 0, bookItem.numberRoom ?? 0));
                    _bookingBloc.add(EditBooking(id: bookItem.id ?? ''));
                    _roomBloc.add(AddInRoom(bookItem.room ?? '',
                        bookItem.numberGuest ?? 0, bookItem.numberRoom ?? 0));
                  }
                  _bookingBloc.close();
                  _roomBloc.close();
                }
              }
            },
          ),
          BlocListener<RoomBloc, RoomState>(listener: (context, state) {
            if (state is RoomAdded) {
              _roomBloc.add(LoadRoom());
            }
          })
        ],
        child: CustomAppBarItem(
            title: 'Hotels',
            isIcon: true,
            filterButton: const FilterHotel(),
            showModalBottomSheet: _callModalBottomSheet,
            child: BlocBuilder<HotelBloc, HotelState>(
              bloc: hotelBloc,
              builder: (context, state) {
                //print(state);
                if (state is HotelLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HotelLoaded) {
                  hotels = state.hotels;
                  return ListView.separated(
                    itemCount: hotels.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(right: 16.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        16.0,
                                      ),
                                      bottomRight: Radius.circular(
                                        16.0,
                                      ),
                                    ),
                                    child: Image.network(
                                      hotels[i].hotelImage ?? "",
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: hotelLiked.any((element) =>
                                              element.id == hotels[i].id)
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  hotelLiked.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          hotels[i].id);
                                                });
                                                List<String> hotelString =
                                                    hotelLiked
                                                        .map((e) => jsonEncode(
                                                            e.toDocument()))
                                                        .toList();
                                                SharedService.setLikedHotels(
                                                    hotelString);
                                              },
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.redAccent,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  hotelLiked.add(hotels[i]);
                                                });
                                                List<String> hotelString =
                                                    hotelLiked
                                                        .map((e) => jsonEncode(
                                                            e.toDocument()))
                                                        .toList();
                                                SharedService.setLikedHotels(
                                                    hotelString);
                                              },
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.white,
                                              )))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotels[i].hotelName ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Color(0xFFF77777),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(hotels[i].location ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(color: Colors.black)),
                                      // Text(
                                      //   ' - ${hotelModel.location_description} from destination',
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .bodyMedium
                                      //       ?.copyWith(color: const Color(0xFF838383)),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(hotels[i].star.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(color: Colors.black)),
                                      Text(
                                          ' (${hotels[i].numberOfReview} reviews)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xFF838383))),
                                    ],
                                  ),
                                  const DashLineWidget(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '\$${hotels[i].price.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                        color: Colors.black)),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text('/night',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                DetailHotelScreen.routeName,
                                                arguments: hotels[i]);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Color(0xff8F67E8),
                                                  Color(0xff6155CC)
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Book a room',
                                            ),
                                          ),
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
                    },
                    separatorBuilder: (context, i) {
                      return const SizedBox();
                    },
                  );
                }
                return const SizedBox();
              },
            )),
      ),
    );
  }
}
