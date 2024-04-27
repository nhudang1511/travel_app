import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_flight_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/booking_flight_repository.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../bloc/bloc.dart';
import 'booking_flight_item.dart';

class BookingFlightBriefcase extends StatefulWidget {
  const BookingFlightBriefcase({super.key});

  @override
  State<BookingFlightBriefcase> createState() => _BookingFlightBriefcaseState();
}

class _BookingFlightBriefcaseState extends State<BookingFlightBriefcase> {
  late BookingFlightBloc _bookingFlightBloc;

  @override
  void initState() {
    super.initState();
    _bookingFlightBloc = BookingFlightBloc(BookingFlightRepository())
      ..add(LoadBookingFlightByEmail(email: SharedService.getEmail() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bookingFlightBloc,
      child: BlocBuilder<BookingFlightBloc, BookingFlightState>(
        builder: (context, state) {
          List<BookingFlightModel> bookingFlight = [];
          if (state is BookingFlightListLoaded) {
            bookingFlight = state.bookingFlights;
          }
          return MasonryGridView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: bookingFlight.length,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, BookingFlightItem.routeName,
                            arguments: bookingFlight[index]);
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
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Icon(Icons.flight, size: 25),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    bookingFlight[index].createdAt != null
                                        ? 'Booking ${bookingFlight[index].createdAt?.toDate()}'
                                        : 'Booking',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.black)),
                                Text('Flight: ${bookingFlight[index].flight}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
        },
      ),
    );
  }
}
