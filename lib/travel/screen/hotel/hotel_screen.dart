import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/detail_hotel/detail_hotel_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/hotel/components/hotel_filter_button.dart';
import '../../bloc/hotel/hotel_bloc.dart';
import '../../model/hotel_model.dart';
import '../../widget/custom_appbar_item.dart';
import 'item_hotel.dart';

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
  HotelBloc hotelBloc = HotelBloc(HotelRepository(RoomRepository()));
  List<HotelModel> hotels = [];
  num rating = 0.0;

  @override
  void initState() {
    super.initState();
    hotelBloc = HotelBloc(HotelRepository(RoomRepository()))
      ..add(LoadHotelByBooking(
          widget.maxGuest, widget.maxRoom, widget.destination));
    // hotelBloc.add(
    //     HotelEventStart(widget.maxGuest, widget.maxRoom, widget.destination));
    // scrollController.addListener(_onScroll);
  }

  // void _onScroll() {
  //   if (scrollController.position.pixels ==
  //           scrollController.position.maxScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     hotelBloc.add(HotelEventFetchMore(
  //         widget.maxGuest, widget.maxRoom, widget.destination));
  //   }
  // }

  @override
  void dispose() {
    hotelBloc.close();
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
    return CustomAppBarItem(
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
              // } else if (state is HotelLoaded) {
              //   return Center(
              //     child: Text(
              //       'No Posts',
              //       style: Theme.of(context).textTheme.displayMedium,
              //     ),
              //   );
            } else if (state is HotelLoaded) {
              hotels = state.hotels;
              return ListView.separated(
                //controller: scrollController,
                itemCount:
                    //state.hasMoreHotel ? state.hotel.length + 1 :
                    hotels.length,
                itemBuilder: (context, i) {
                  // if (i >= state.hotel.length) {
                  //   return Container(
                  //     margin: const EdgeInsets.only(top: 15),
                  //     height: 100,
                  //     width: 30,
                  //     child: const Center(child: CircularProgressIndicator()),
                  //   );
                  // }
                  return ItemHotelWidget(
                    hotelModel: hotels[i],
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          DetailHotelScreen.routeName,
                          arguments: hotels[i]);
                    },
                  );
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
