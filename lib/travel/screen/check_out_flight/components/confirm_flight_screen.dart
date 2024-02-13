import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/booking_flight/booking_flight_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/card_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/filght_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/check_out_screen_flight.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/item_total_flight.dart';
import 'package:flutter_nhu_nguyen/travel/screen/confirm/components/item_card.dart';
import 'package:flutter_nhu_nguyen/travel/screen/finish_checkout/finish_checkout_flight_screen.dart';
import '../../../../config/shared_preferences.dart';
import '../../../model/seat_model.dart';
import '../../../widget/custom_button.dart';

class ConfirmFlightScreen extends StatefulWidget {
  const ConfirmFlightScreen({super.key, required this.flightModel});

  final FlightModel flightModel;

  static const String routeName = '/confirm_flight';

  @override
  State<ConfirmFlightScreen> createState() => _ConfirmFlightScreenState();
}

class _ConfirmFlightScreenState extends State<ConfirmFlightScreen> {
  late BookingFlightBloc _bookingFlightBloc;
  CardModel? card;
  String? cardString = SharedService.getCard();
  String? promoString = SharedService.getPromo();
  List<String> contactList = SharedService.getListContacts();
  List<Guest> guests = List.empty(growable: true);
  List<Seat> seats = List.empty(growable: true);
  List<String> seatStringList = SharedService.getListSeat();

  @override
  void initState() {
    super.initState();
    _bookingFlightBloc = BlocProvider.of<BookingFlightBloc>(context);
    print(widget.flightModel.airline);
    if (contactList.isNotEmpty) {
      guests =
          contactList.map((e) => Guest.fromDocument(json.decode(e))).toList();
    }
    if (cardString != null) {
      card = CardModel.fromDocument(json.decode(cardString!));
    }
    if(seatStringList.isNotEmpty){
      seats =
          seatStringList.map((e) => Seat.fromDocument(json.decode(e))).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24.0,
        ),
        ItemCheckoutFlight(flight: widget.flightModel, guest: guests[0],seat: seats[0]),
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
                _bookingFlightBloc.add(AddBooking(
                    price: 100,
                    flight: widget.flightModel.airline,
                    card: card,
                    createdAt: DateTime.now(),
                    email: guests[0].email ?? "",
                    guest: guests,
                    promoCode: promoString,
                    seat: seats,
                    typePayment: SharedService.getTypePayment() ?? ""));
                sharedServiceClear();
                SharedService.clear("seats");
                Navigator.pushNamed(
                  context,
                  FinishCheckoutFlightScreen.routeName,
                );
              },
            ).show();
          },
        ),
        const SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
