import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../config/shared_preferences.dart';
import '../../../bloc/bloc.dart';
import '../../../model/booking_model.dart';
import '../../../model/hotel_model.dart';
import '../../../repository/repository.dart';

class BookingHotelStatistical extends StatefulWidget {
  const BookingHotelStatistical({super.key});

  @override
  State<BookingHotelStatistical> createState() => _BookingHotelStatisticalState();
}

class _BookingHotelStatisticalState extends State<BookingHotelStatistical> {
  String shortenText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      int endIndex =
          maxLength - 3; // Giảm ba ký tự để có chỗ cho dấu chấm ba chấm
      while (endIndex > 0 && text[endIndex] != ' ') {
        endIndex--;
      }
      return '${text.substring(0, endIndex)}...';
    }
  }
  DateTime? _selected;
  late BookingBloc _bookingBloc;
  late HotelBloc _hotelBloc;
  double totalPrices = 0;
  int typeCard = 0;
  int typeBank = 0;

  String? getHotelNameFromId(String hotelId, List<HotelModel> hotels) {
    var hotel = hotels.firstWhere((hotel) => hotel.id == hotelId);
    return hotel.hotelName;
  }

  List<ChartData> chartData(List<BookingModel> listBooking, List<HotelModel> hotels) {
    Map<String, int> bookingCounts = {};

    // Tính số lượng booking cho mỗi khách sạn
    for (var booking in listBooking) {
      if (booking.hotel != null) {
        var hotelName = getHotelNameFromId(booking.hotel!, hotels);
        if (hotelName != null) {
          if (bookingCounts.containsKey(hotelName)) {
            bookingCounts[hotelName] = (bookingCounts[hotelName]! + 1);
          } else {
            bookingCounts[hotelName] = 1;
          }
        }
      }
    }

    // Tạo danh sách ChartData từ số lượng booking đã tính được
    List<ChartData> data = [];
    bookingCounts.forEach((hotelName, count) {
      data.add(ChartData(hotelName, count));
    });
    if(data.isEmpty){
      totalPrices = 0;
      typeBank = 0;
      typeCard = 0;
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    _bookingBloc = BookingBloc(BookingRepository())
      ..add(LoadBookingByMonth(
          createdAt: DateTime.now(), email: SharedService.getEmail() ?? ''));
    _hotelBloc = HotelBloc(HotelRepository(RoomRepository()))..add(LoadHotels());
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _bookingBloc,
        ),
        BlocProvider(
          create: (context) => _hotelBloc,
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                child: _selected != null
                    ? Text('${_selected?.month} / ${_selected?.year}')
                    : Text(
                    '${DateTime.now().month} / ${DateTime.now().year}'),
                onPressed: () async {
                  final selected = await showMonthYearPicker(
                    context: context,
                    initialDate: _selected ?? DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2030),
                    initialMonthYearPickerMode: MonthYearPickerMode.year,
                  );
                  if (selected != null) {
                    setState(() {
                      _selected = selected;
                      totalPrices = 0;
                      typeBank = 0;
                      typeCard = 0;
                      _bookingBloc.add(LoadBookingByMonth(
                          createdAt: _selected ?? DateTime.now(),
                          email: SharedService.getEmail() ?? ''));
                    });
                  }
                }),
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                List<BookingModel> bookingModel = [];
                if (state is BookingLoaded) {
                  bookingModel = state.bookingModel;
                  for(var book in bookingModel){
                    totalPrices = book.price! + totalPrices;
                    if(book.typePayment == 'Card'){
                      typeCard = typeCard + 1;
                    }
                    else if(book.typePayment == 'Bank Transfer'){
                      typeBank = typeBank + 1;
                    }
                  }
                }
                return BlocBuilder<HotelBloc, HotelState>(
                  builder: (context, state) {
                    List<HotelModel> hotels = [];
                    if(state is HotelLoaded){
                      hotels = state.hotels;
                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.all(10),
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(
                                    color: Colors.black), // Màu chữ trục x
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                    color: Colors.black), // Màu chữ trục y
                              ),
                              series: <ChartSeries>[
                                StackedColumnSeries<ChartData, String>(
                                    dataSource: chartData(bookingModel, hotels),
                                    xValueMapper: (ChartData data, _) =>
                                        shortenText(data.x, 25),
                                    yValueMapper: (ChartData data, _) => data.y,
                                    color: Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0x59787ECF)),
                                child: Column(
                                  children: [
                                    Text('Total prices: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center),
                                    Text(totalPrices.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0x59787ECF)),
                                child: Column(
                                  children: [
                                    Text('Card: $typeCard ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center),
                                    Text('Bank Transfer: $typeBank ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(color: Colors.white),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                    else{
                      return const SizedBox();
                    }
                  },
                );
              },
            ),
          ],
        ),
      )
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int y;
}

