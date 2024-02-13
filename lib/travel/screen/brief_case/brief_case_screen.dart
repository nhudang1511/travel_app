import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/booking_repository.dart';
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
  final dateFormatter = DateFormat('dd MMM yyyy');
  String? email;

  @override
  void initState() {
    _bookingBloc = BookingBloc(BookingRepository())..add(LoadBooking());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bookingBloc,
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
                                crossAxisCount: 2),
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 16),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  BookingItem.routeName,
                                                  arguments:
                                                      bookings[index].id);
                                              print(bookings[index].id);
                                            },
                                            icon: const Icon(Icons.home_filled))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Text(
                                        bookings[index].createdAt != null
                                            ? 'Booking ${dateFormatter.format(bookings[index].createdAt!)}'
                                            : 'Booking',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(color: Colors.black)),
                                  ),
                                ],
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
  const BookingItem({super.key, required this.bookingId});

  static const String routeName = '/item_booking';

  @override
  State<BookingItem> createState() => _BookingItemState();
  final String bookingId;
}

class _BookingItemState extends State<BookingItem> {
  List<BookingModel>? bookingModel;
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
        if (state is BookingLoaded) {
          bookingModel = state.bookingModel;
          if (bookingModel?.first.dateStart != null &&
              bookingModel?.first.dateEnd != null) {
            Duration? duration = bookingModel?.first.dateEnd
                ?.difference(bookingModel?.first.dateStart ?? DateTime.now());
            daysDifference = duration?.inDays;
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
                            Text(
                              'Hotel: ${bookingModel?.first.hotel}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Room: ${bookingModel?.first.room}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Email: ${bookingModel?.first.email}',
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
        );
      },
    );
  }
}
