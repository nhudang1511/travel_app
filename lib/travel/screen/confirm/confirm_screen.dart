import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';
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
  DateFormat dateFormat = DateFormat('dd MMM yyyy');
  late RoomBloc _roomBloc;
  int total = 0;
  int discount = 0;

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
                "total": "${total - discount}",
                "currency": "USD",
                "details": {
                  "subtotal": "$total",
                  "shipping": '0',
                  "shipping_discount": discount
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
                    "price": "$total",
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
            BookingModel bookingModel = BookingModel(
                email: SharedService.getEmail(),
                hotel: widget.roomModel.hotel,
                room: widget.roomModel.id,
                guest: guests,
                typePayment: SharedService.getTypePayment() ?? "",
                card: card,
                dateStart: Timestamp.fromDate(
                    dateFormat.parse(SharedService.getStartDate() ?? '')),
                dateEnd: Timestamp.fromDate(
                    dateFormat.parse(SharedService.getEndDate() ?? '')),
                status: true,
                createdAt: Timestamp.fromDate(DateTime.now()),
                expired: false,
                numberGuest: SharedService.getGuest() ?? 1,
                numberRoom: SharedService.getRoom() ?? 1,
                price: total - discount);
            _bookingBloc.add(
              AddBooking(bookingModel: bookingModel),
            );
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
      if (SharedService.getBookingId() == null ||
          SharedService.getBookingId() == "") {
        await Navigator.pushNamed(context, BankTransferScreen.routeName);
        BookingModel bookingModel = BookingModel(
            email: SharedService.getEmail(),
            hotel: widget.roomModel.hotel,
            room: widget.roomModel.id,
            guest: guests,
            typePayment: SharedService.getTypePayment() ?? "",
            card: card,
            dateStart: Timestamp.fromDate(
                dateFormat.parse(SharedService.getStartDate() ?? '')),
            dateEnd: Timestamp.fromDate(
                dateFormat.parse(SharedService.getEndDate() ?? '')),
            status: false,
            createdAt: Timestamp.fromDate(DateTime.now()),
            expired: false,
            numberGuest: SharedService.getGuest() ?? 1,
            numberRoom: SharedService.getRoom() ?? 1,
            price: total - discount);
        _bookingBloc.add(AddBooking(bookingModel: bookingModel));
        sharedServiceClear();
      } else {
        _bookingBloc.add(LoadBookingById(id: SharedService.getBookingId()!));
      }
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
    _roomBloc = RoomBloc(RoomRepository())..add(LoadRoom());
    SharedService.setBookingId("");
    int price = widget.roomModel.price?.toInt() ?? 1;
    int room = SharedService.getRoom() ?? 1;
    int date = SharedService.getDays() ?? 1;
    total = price * room * date;
    double promo = SharedService.getPromo() ?? 0;
    discount =  (price * room * date * promo).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _roomBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              //print(state);
              // print('id ${SharedService.getBookingId()}');
              if (state is BookingAdded) {
                if (state.bookingModel.id != null) {
                  SharedService.setBookingId(state.bookingModel.id!);
                }
                if (state.bookingModel.status == true) {
                  //print('num ${state.bookingModel.numberGuest}');
                  _bookingBloc
                      .add(LoadBookingById(id: SharedService.getBookingId()!));
                  // _hotelBloc.add(RemoveInHotel(
                  //     widget.roomModel.hotel ?? '',
                  //     state.bookingModel.numberGuest ?? 1,
                  //     state.bookingModel.numberRoom ?? 1));
                  _roomBloc.add(RemoveInRoom(widget.roomModel.id ?? '',
                      state.bookingModel.numberRoom ?? 1));

                  sharedServiceClear();
                  Navigator.pushNamed(context, FinishCheckoutScreen.routeName);
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
                            'Please wait a few minutes for admin to confirm the transfer.'
                            ' And please transfer before exiting the application',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        btnOkOnPress: () {
                          if (SharedService.getBookingId() != null) {
                            _bookingBloc.add(LoadBookingById(
                                id: SharedService.getBookingId()!));
                          }
                        }).show();
                  });
                }
              } else if (state is BookingLoadedById) {
                if (state.bookingModel.status == true) {
                  // _hotelBloc.add(RemoveInHotel(
                  //     widget.roomModel.hotel ?? '',
                  //     state.bookingModel.numberGuest ?? 1,
                  //     state.bookingModel.numberRoom ?? 1));
                  _roomBloc.add(RemoveInRoom(widget.roomModel.id ?? '',
                      state.bookingModel.numberRoom ?? 1));
                  Navigator.pushNamed(context, FinishCheckoutScreen.routeName);
                  sharedServiceClear();
                } else {
                  _bookingBloc
                      .add(LoadBookingById(id: SharedService.getBookingId()!));
                }
              }
            },
          ),
          BlocListener<RoomBloc, RoomState>(listener: (context, state) {
            //print(state);
          })
        ],
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
      ),
    );
  }
}
