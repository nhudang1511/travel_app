import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/confirm/components/bank_transfer_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/confirm/components/item_card.dart';
import 'package:flutter_nhu_nguyen/travel/screen/confirm/components/item_confirm_room.dart';
import 'package:flutter_nhu_nguyen/travel/screen/confirm/components/item_total.dart';
import 'package:flutter_nhu_nguyen/travel/screen/finish_checkout/finish_checkout_screen.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

import '../../../config/shared_preferences.dart';
import '../../model/booking_model.dart';
import '../../model/card_model.dart';
import '../../model/guest_model.dart';
import '../../widget/widget.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key, required this.roomModel});

  final RoomModel roomModel;

  static const String routeName = '/confirm';

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late BookingBloc _bookingBloc;
  BookingModel? bookingModel;
  List<String> contactList = SharedService.getListContacts();
  List<Guest> guests = List.empty(growable: true);
  CardModel? card;
  String? cardString = SharedService.getCard();
  String? promoString = SharedService.getPromo();
  DateFormat dateFormat = DateFormat('dd MMM yyyy');

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
                "total": "${widget.roomModel.price}",
                "currency": "USD",
                "details": {
                  "subtotal": "${widget.roomModel.price}",
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
                    "name": "${widget.roomModel.name}",
                    "quantity": (SharedService.getRoom() != null)
                        ? SharedService.getRoom()
                        : 1,
                    "price": "${widget.roomModel.price}",
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
            _bookingBloc.add(AddBooking(
                email: SharedService.getEmail(),
                hotel: widget.roomModel.hotel,
                room: widget.roomModel.id,
                guest: guests,
                typePayment: SharedService.getTypePayment() ?? "",
                card: card,
                promoCode: promoString,
                dateStart: dateFormat.parse(SharedService.getStartDate() ?? ""),
                dateEnd: dateFormat.parse(SharedService.getEndDate() ?? ""),
                createdAt: DateTime.now()));
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
    }
    else if(SharedService.getTypePayment() == 'Bank Transfer'){
      Navigator.pushNamed(context, BankTransferScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    _bookingBloc = BlocProvider.of<BookingBloc>(context);
    if (contactList.isNotEmpty) {
      guests =
          contactList.map((e) => Guest.fromDocument(json.decode(e))).toList();
    }
    if (cardString != null) {
      card = CardModel.fromDocument(json.decode(cardString!));
    }

    // print('guest len: ${guests.length}');
    // print('card len: ${card?.name}');
    // print("promo ${promo.price}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if(state is BookingAdded){
          Navigator.pushNamed(context, FinishCheckoutScreen.routeName,);
        }
      },
      child: Column(
        children: [
          const SizedBox(
            height: 24.0,
          ),
          ItemConfirmRoomWidget(roomModel: widget.roomModel),
          ItemTotal(
            price: widget.roomModel.price ?? 0,
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
                desc: 'Are you sure order this hotels',
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
    );
  }
}
