import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_flight_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/filght_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/flight_repository.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../config/shared_preferences.dart';
import 'booking_hotel_statistical.dart';

class BookingFlightStatistical extends StatefulWidget {
  const BookingFlightStatistical({super.key});

  @override
  State<BookingFlightStatistical> createState() =>
      _BookingFlightStatisticalState();
}

class _BookingFlightStatisticalState extends State<BookingFlightStatistical> {
  DateTime? _selected;
  late BookingFlightBloc _bookingFlightBloc;
  late FlightBloc _flightBloc;
  double totalPrices = 0;
  int typeCard = 0;
  int typeBank = 0;

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

  List<ChartData> chartData(
      List<BookingFlightModel> listBooking, List<FlightModel> flights) {
    Map<String, int> bookingCounts = {};
    for (var booking in listBooking) {
      if (booking.flight != null) {
        var flightName = booking.flight;
        if (flightName != null) {
          if (bookingCounts.containsKey(flightName)) {
            bookingCounts[flightName] = (bookingCounts[flightName]! + 1);
          } else {
            bookingCounts[flightName] = 1;
          }
        }
      }
    }

    // Tạo danh sách ChartData từ số lượng booking đã tính được
    List<ChartData> data = [];
    bookingCounts.forEach((flightName, count) {
      data.add(ChartData(flightName, count));
    });
    if(data.isEmpty){
      totalPrices = 0;
      typeCard = 0;
      totalPrices = 0;
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    _bookingFlightBloc = BookingFlightBloc(BookingFlightRepository())
      ..add(LoadBookingFlightByByMonth(
          createdAt: DateTime.now(), email: SharedService.getEmail() ?? ''));

    _flightBloc = FlightBloc(FlightRepository())..add(LoadAllFlight());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _bookingFlightBloc,
        ),
        BlocProvider(
          create: (context) => _flightBloc,
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                child: _selected != null
                    ? Text('${_selected?.month} / ${_selected?.year}')
                    : Text('${DateTime.now().month} / ${DateTime.now().year}'),
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
                      _bookingFlightBloc.add(LoadBookingFlightByByMonth(
                          createdAt: _selected ?? DateTime.now(),
                          email: SharedService.getEmail() ?? ''));
                      totalPrices = 0;
                      typeBank = 0;
                      typeCard = 0;
                    });
                  }
                }),
            BlocBuilder<BookingFlightBloc, BookingFlightState>(
              builder: (context, state) {
                List<BookingFlightModel> bookingFlightModel = [];
                if (state is BookingFlightListLoaded) {
                  bookingFlightModel = state.bookingFlights;
                  for(var book in bookingFlightModel){
                    totalPrices = book.price! + totalPrices;
                    if(book.typePayment == 'Card'){
                      typeCard = typeCard + 1;
                    }
                    else if(book.typePayment == 'Bank Transfer'){
                      typeBank = typeBank + 1;
                    }
                  }
                }
                return BlocBuilder<FlightBloc, FlightState>(
                  builder: (context, state) {
                    List<FlightModel> flights = [];
                    if(state is FlightLoaded){
                      flights = state.flights;
                    }
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
                                  dataSource: chartData(bookingFlightModel, flights),
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
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
