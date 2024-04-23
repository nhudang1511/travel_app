import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/booking_flight/booking_flight_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/card_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/filght_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/flight_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/check_out_screen_flight.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/item_total_flight.dart';
import 'package:flutter_nhu_nguyen/travel/screen/confirm/components/item_card.dart';
import 'package:flutter_nhu_nguyen/travel/screen/finish_checkout/finish_checkout_flight_screen.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import '../../../../config/shared_preferences.dart';
import '../../../bloc/flight/flight_bloc.dart';
import '../../../model/seat_model.dart';
import '../../../widget/custom_button.dart';
import '../../confirm/components/bank_transfer_screen.dart';

class ConfirmFlightScreen extends StatefulWidget {
  const ConfirmFlightScreen({super.key, required this.flightModel});

  final FlightModel flightModel;

  static const String routeName = '/confirm_flight';

  @override
  State<ConfirmFlightScreen> createState() => _ConfirmFlightScreenState();
}

class _ConfirmFlightScreenState extends State<ConfirmFlightScreen> {
  late BookingFlightBloc _bookingFlightBloc;
  late FlightBloc _flightBloc;
  CardModel? card;
  String? cardString = SharedService.getCard();
  String? promoString = SharedService.getPromo();
  List<String> contactList = SharedService.getListContacts();
  List<Guest> guests = List.empty(growable: true);
  List<Seat> seats = List.empty(growable: true);
  List<String> seatStringList = SharedService.getListSeat();

  Future<void> confirm() async {
    if (SharedService.getTypePayment() == 'Card') {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckout(
          sandboxMode: true,
          clientId:
              "AaaW59YSr4jLqnzjakTcxIqSJmXp7wCTMXAFlKQkhEas5VsSoiCCLxUONEmxD7TDS-yWGDo870kL4s7k",
          secretKey:
              "EL-9xaj1hT9t_BewhWN7CuIykI0_5nux_JT35vSPvO35kyUmlRUpZLhx_SllV6P3YqLnth2CP-RJGy-V",
          returnURL: "success.snippetcoder.com",
          cancelURL: "cancel.snippetcoder.com",
          transactions: [
            {
              "amount": {
                "total": "${widget.flightModel.price}",
                "currency": "USD",
                "details": {
                  "subtotal": "${widget.flightModel.price}",
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              // "payment_options": {
              //   "allowed_payment_method":
              //       "INSTANT_FUNDING_SOURCE"
              // },
              "item_list": {
                "items": [
                  {
                    "name": "${widget.flightModel.airline}",
                    "quantity": 1,
                    "price": "${widget.flightModel.price}",
                    "currency": "USD"
                  },
                  // {
                  //   "name": "Pineapple",
                  //   "quantity": 1,
                  //   "price": '10',
                  //   "currency": "USD"
                  // }
                ],
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            print("onSuccess: $params");
            _bookingFlightBloc.add(AddBookingFlight(
                price: 100,
                flight: widget.flightModel.airline,
                card: card,
                createdAt: DateTime.now(),
                email: guests[0].email ?? "",
                guest: guests,
                promoCode: promoString,
                seat: seats,
                status: true,
                typePayment: SharedService.getTypePayment() ?? ""));
            sharedServiceClear();
          },
          onError: (error) {
            print("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            print('cancelled:');
          },
        ),
      ));
    } else if (SharedService.getTypePayment() == 'Bank Transfer') {
      if (SharedService.getBookingFlightId() == null) {
        await Navigator.pushNamed(context, BankTransferScreen.routeName);
        _bookingFlightBloc.add(AddBookingFlight(
            price: 100,
            flight: widget.flightModel.airline,
            card: card,
            createdAt: DateTime.now(),
            email: guests[0].email ?? "",
            guest: guests,
            promoCode: promoString,
            seat: seats,
            status: false,
            typePayment: SharedService.getTypePayment() ?? ""));
        sharedServiceClear();
      } else {
        _bookingFlightBloc.add(
            LoadBookingFlightById(id: SharedService.getBookingFlightId()!));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _bookingFlightBloc = BlocProvider.of<BookingFlightBloc>(context);
    //print(widget.flightModel.airline);
    if (contactList.isNotEmpty) {
      guests =
          contactList.map((e) => Guest.fromDocument(json.decode(e))).toList();
    }
    if (cardString != null) {
      card = CardModel.fromDocument(json.decode(cardString!));
    }
    if (seatStringList.isNotEmpty) {
      seats =
          seatStringList.map((e) => Seat.fromDocument(json.decode(e))).toList();
    }
    _flightBloc = FlightBloc(FlightRepository())..add(LoadFlight());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _flightBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookingFlightBloc, BookingFlightState>(
            listener: (context, state) {
              //print(state);
              if (state is BookingFlightAdded) {
                if (state.bookingFlightModel.id != null) {
                  SharedService.setBookingFlightId(
                      state.bookingFlightModel.id!);
                }
                if (state.bookingFlightModel.status == true) {
                  _bookingFlightBloc.add(LoadBookingFlightById(
                      id: SharedService.getBookingFlightId()!));
                  _flightBloc.add(EditFlight(
                      flightId: widget.flightModel.id ?? '', seat: seats));
                  Navigator.pushNamed(
                      context, FinishCheckoutFlightScreen.routeName);
                } else {
                  Future.delayed(const Duration(seconds: 3), () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        title: 'Warning',
                        titleTextStyle: const TextStyle(color: Colors.black),
                        descTextStyle: const TextStyle(color: Colors.black),
                        desc:
                            'Please wait a few minutes for admin to confirm the transfer',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        btnOkOnPress: () {
                          if (SharedService.getBookingFlightId() != null) {
                            _bookingFlightBloc.add(LoadBookingFlightById(
                                id: SharedService.getBookingFlightId()!));
                          }
                        }).show();
                  });
                }
              } else if (state is BookingFlightLoaded) {
                if (state.bookingFlightModel.status == true) {
                  _flightBloc.add(EditFlight(
                      flightId: widget.flightModel.id ?? '', seat: seats));
                  Navigator.pushNamed(
                      context, FinishCheckoutFlightScreen.routeName);
                  SharedService.clear("seats");
                  sharedServiceClear();
                } else {
                  _bookingFlightBloc.add(LoadBookingFlightById(
                      id: SharedService.getBookingFlightId()!));
                }
              }
            },
          ),
          BlocListener<FlightBloc, FlightState>(listener: (context, state) {
            //print(state);
            if (state is FlightLoaded) {
              //print(state.flights.length);
            }
          })
        ],
        child: Column(
          children: [
            const SizedBox(
              height: 24.0,
            ),
            ItemCheckoutFlight(
                flight: widget.flightModel, guest: guests[0], seat: seats[0]),
            const SizedBox(
              height: 24.0,
            ),
            ItemTotalFlight(
              price: widget.flightModel.price ?? 0,
            ),
            const ItemCard(),
            CustomButton(
              title: 'Done',
              button: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: false,
                  animType: AnimType.bottomSlide,
                  title: 'Warning',
                  titleTextStyle: const TextStyle(color: Colors.black),
                  descTextStyle: const TextStyle(color: Colors.black),
                  desc: 'Are you sure order this flight',
                  buttonsTextStyle: const TextStyle(color: Colors.black),
                  showCloseIcon: true,
                  btnOkOnPress: () {
                    confirm();
                  },
                ).show();
              },
            ),
            const SizedBox(
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
