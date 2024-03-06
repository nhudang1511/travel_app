import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/config/image_helper.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/rpscustom_painter.dart';
import 'package:flutter_nhu_nguyen/travel/widget/widget.dart';
import 'package:book_my_seat/book_my_seat.dart';

import '../../../../config/shared_preferences.dart';
import '../../../model/filght_model.dart';
import '../../../model/seat_model.dart';

class SelectSeatScreen extends StatefulWidget {
  const SelectSeatScreen({super.key, required this.flight});
  static const String routeName = '/seat';
  final FlightModel flight;

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  List<List<SeatState>> _convertSeatData(Map<String, dynamic>? seatData) {
    if (seatData == null) {
      return List.generate(0, (index) => []);
    }

    return seatData.entries.map((entry) {
      List<bool> rowData = (entry.value as List<dynamic>).cast<bool>();

      // If the length of the array is even, add SeatState.empty in the middle
      if (rowData.length % 2 == 0) {
        int middleIndex = rowData.length ~/ 2;
        rowData.insert(middleIndex, false);
      }

      return rowData.asMap().entries.map((MapEntry<int, bool> mapEntry) {
        int index = mapEntry.key;
        bool value = mapEntry.value;

        if (value == true) {
          return SeatState.unselected;
        } else {
          // If it's the added SeatState.empty, return SeatState.empty
          if (index == rowData.length ~/ 2) {
            return SeatState.empty;
          } else {
            return SeatState.disabled;
          }
        }
      }).toList();
    }).toList();
  }
  List<List<SeatState>>? businessClassSeats;
  List<List<SeatState>>? economyClassSeats;
  List<Seat> seats = List.empty(growable: true);
  List<String> seatStringList = SharedService.getListSeat();
  @override
  void initState(){
    super.initState();
    businessClassSeats = _convertSeatData(widget.flight.seat?[0]);
    economyClassSeats = _convertSeatData(widget.flight.seat?[1]);
    //print(economyClassSeats);
    if (seatStringList.isNotEmpty) {
      seats =
          seatStringList.map((e) => Seat.fromDocument(json.decode(e))).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
        title: 'Select Seat',
        isIcon: false,
        showModalBottomSheet: () {  },
        child: Stack(
          children: [
            Positioned(
              top: 100,
              child: Container(
                width: 100,
                height: 150,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppPath.iconSeat),
                          const SizedBox(width: 10,),
                          Column(
                            children: [
                              Text('Seat', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF636363)),),
                              const SizedBox(height: 5,),
                              Text(
                               seats.isNotEmpty ? seats[0].name ?? '' : '',
                                style: const TextStyle(
                                  color: Color(0xFF6155CC),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Text(
                        seats.isNotEmpty ? seats[0].type ?? '': '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 85,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE0DDF5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text('${widget.flight.price}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: const Color(0xFF6155CC))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: Column(
                children: [
                  Text(widget.flight.from_place ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: const Color(0xFF6155CC))),
                  const SizedBox(
                    height: 20,
                  ),
                  ImageHelper.loadFromAsset(AppPath.flight),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(widget.flight.to_place ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: const Color(0xFF6155CC))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    CustomPaint(
                      painter: RPSCustomPainter(),
                      size: const Size(240, 650),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height / 4 + 35,
                        left: 15,
                        child: Column(
                          children: [
                            Text(
                              "Bussiness Class",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            FlightSeat(
                              cols: 5,
                              rows: 3,
                              currentSeatsState: businessClassSeats ?? [],
                              type: "Business"
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Economy Class",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            FlightSeat(
                              cols: 7,
                              rows: 4,
                              currentSeatsState: economyClassSeats ?? [],
                              type: "Economy",
                            )
                          ],
                        )),
                  ],
                ),
              ],
            ),
            Positioned(
                bottom: -15,
                width: MediaQuery.of(context).size.width - 30,
                child: CustomButton(
                  title: 'Processed',
                  button: () {
                    Navigator.pop(context);
                  },
                ))
          ],
        ));
  }
}

class FlightSeat extends StatefulWidget {
  const FlightSeat(
      {Key? key,
      required this.cols,
      required this.rows,
      required this.currentSeatsState, required this.type})
      : super(key: key);

  @override
  State<FlightSeat> createState() => _FlightSeatState();
  final int cols;
  final int rows;
  final List<List<SeatState>> currentSeatsState;
  final String type;
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI && colI == (other).colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}

class _FlightSeatState extends State<FlightSeat> {
  Set<SeatNumber> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return SeatLayoutWidget(
      type: widget.type,
      onSeatStateChanged: (rowI, colI, seatState) {
        if (seatState == SeatState.selected) {
          selectedSeats.add(SeatNumber(rowI: rowI, colI: colI));
        } else {
          selectedSeats.remove(SeatNumber(rowI: rowI, colI: colI));
        }
      },
      stateModel: SeatLayoutStateModel(
          rows: widget.rows,
          cols: widget.cols,
          seatSvgSize: 30,
          pathSelectedSeat: AppPath.iconSeatSelected,
          pathDisabledSeat: AppPath.iconSeatDisabled,
          pathSoldSeat: AppPath.iconSeatSold,
          pathUnSelectedSeat: AppPath.iconSeatUnselected,
          currentSeatsState: widget.currentSeatsState),
      //type: '',
    );
  }
}
