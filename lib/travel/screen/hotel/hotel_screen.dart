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
  double rating = 0.0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _hotelBloc = HotelBloc(HotelRepository(RoomRepository()))
    //   ..add(LoadHotelByBooking(
    //       widget.maxGuest, widget.maxRoom, widget.destination));
    hotelBloc.add(HotelEventStart());
    scrollController.addListener(_onScroll);
  }
  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      hotelBloc.add(HotelEventFetchMore());
    }
  }

  @override
  void dispose() {
    hotelBloc.close();
    scrollController.dispose();
    super.dispose();
  }

  void _callModalBottomSheet() async {
    Map<String, dynamic> result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const FilterHotel());
    // print("Testing Value: $value");
    String sortValue = result['sort'];

    if (result['rating'] != null) {
      setState(() {
        rating = result['rating'];
      });
    }

    print("Testing Sort Value: $sortValue");
    print("Testing Rating: ${rating.toString()}");

    // Tiếp tục xử lý dữ liệu theo cách bạn muốn
    if (sortValue != 'All') {
      sortHotels(sortValue);
    }
  }

  void sortHotels(String value) {
    setState(() {
      hotels.sort((a, b) {
        dynamic keyA, keyB;
        switch (value) {
          case 'total_review':
            keyA = b.numberOfReview;
            keyB = a.numberOfReview;
            break;
          case 'low_price':
            keyA = a.price;
            keyB = b.price;
            break;
          case 'high_price':
            keyA = b.price;
            keyB = a.price;
          case 'rating':
            keyA = b.star;
            keyB = a.star;
          default:
            // Handle the default case or throw an exception
            throw ArgumentError('Invalid sorting value: $value');
        }

        return keyA.compareTo(keyB);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
        title: 'Hotels',
        isIcon: true,
        filterButton: const FilterHotel(),
        showModalBottomSheet: _callModalBottomSheet,
        child:  BlocBuilder<HotelBloc, HotelState>(
          bloc: hotelBloc,
          builder: (context, state) {
            if (state is HotelStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HotelStateEmpty) {
              return Center(
                child: Text(
                  'No Posts',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              );
            } else if (state is HotelStateLoadSuccess) {
              return ListView.separated(
                controller: scrollController,
                itemCount: state.hasMoreHotel ? state.hotel.length + 1 : state.hotel.length,
                itemBuilder: (context, i) {
                  if (i >= state.hotel.length) {
                    return Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 100,
                      width: 30,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ItemHotelWidget(
                    hotelModel: state.hotel[i],
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          DetailHotelScreen.routeName,
                          arguments: state.hotel[i]);
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
        )
    );
  }
}
