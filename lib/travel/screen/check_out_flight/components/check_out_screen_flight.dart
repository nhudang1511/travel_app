import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:flutter_nhu_nguyen/travel/widget/dashline.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import '../../../../config/app_path.dart';
import '../../../../config/shared_preferences.dart';
import '../../../model/filght_model.dart';
import '../../../model/guest_model.dart';
import '../../../model/promo_model.dart';
import '../../../model/seat_model.dart';
import '../../check_out/components/item_checkout/contact_item.dart';
import '../../check_out/components/item_checkout/promo_item.dart';
import '../../check_out/components/item_options.dart';
import '../../screen.dart';

class CheckOutScreenFlight extends StatefulWidget {
  const CheckOutScreenFlight({super.key, required this.flight});

  static const String routeName = '/check_out_flight';
  final FlightModel flight;

  @override
  State<CheckOutScreenFlight> createState() => _CheckOutScreenFlightState();
}

class _CheckOutScreenFlightState extends State<CheckOutScreenFlight> {
  List<Guest> guests = List.empty(growable: true);
  List<String> contactList = SharedService.getListContacts();
  Promo? promo;
  List<Seat> seats = List.empty(growable: true);
  List<String> seatStringList = SharedService.getListSeat();

  @override
  void initState() {
    super.initState();
    if (contactList.isNotEmpty) {
      guests =
          contactList.map((e) => Guest.fromDocument(json.decode(e))).toList();
    }
    if (seatStringList.isNotEmpty) {
      seats =
          seatStringList.map((e) => Seat.fromDocument(json.decode(e))).toList();
    }
  }


  @override
  void dispose() {
    super.dispose();
    SharedService.clear("seats");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          ItemCheckoutFlight(
            flight: widget.flight,
            guest: guests.isNotEmpty ? guests[0] : Guest(),
            seat: seats.isNotEmpty ? seats[0] : Seat(),
          ),
          const SizedBox(
            height: 24,
          ),
          BuildItemOption(
            icon: AppPath.user,
            title: 'Contact Details',
            value: 'Add Contact',
            onTap: () async {
              var updatedGuests = await Navigator.of(context)
                  .pushNamed(ContactScreen.routeName) as List<Guest>?;
              // Check if the guest list was updated
              if (updatedGuests != null) {
                setState(() {
                  guests = updatedGuests;
                });
              }
            },
            isChoose: guests.isNotEmpty ? true : false,
            child: Column(
              children: guests
                  .map((e) => ContactItem(
                      guest: e,
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          headerAnimationLoop: false,
                          animType: AnimType.bottomSlide,
                          title: 'Warning',
                          titleTextStyle: const TextStyle(color: Colors.black),
                          descTextStyle: const TextStyle(color: Colors.black),
                          desc: 'Are you sure to remove this contact?',
                          buttonsTextStyle:
                              const TextStyle(color: Colors.black),
                          showCloseIcon: true,
                          btnOkOnPress: () {
                            setState(() {
                              guests.remove(e);
                              List<String> contactString = guests
                                  .map((e) => jsonEncode(e.toDocument()))
                                  .toList();
                              SharedService.setListContacts(contactString);
                            });
                          },
                        ).show();
                      }))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          BuildItemOption(
            icon: AppPath.seats,
            title: 'Passengers & Seats',
            value: 'Add Passenger',
            child: seats.isNotEmpty
                ? ItemSeat(flight: widget.flight, seats: seats)
                : const SizedBox(),
            onTap: () async {
              var newSeats = await Navigator.of(context).pushNamed(
                  SelectSeatScreen.routeName,
                  arguments: widget.flight) as List<String>?;
              if (newSeats != null) {
                setState(() {
                  seats = newSeats
                      .map((e) => Seat.fromDocument(json.decode(e)))
                      .toList();
                });
              }
            },
          ),
          const SizedBox(
            height: 24,
          ),
          BuildItemOption(
            icon: AppPath.promo,
            title: 'Promo Code',
            value: 'Add Promo Code',
            isChoose: promo != null ? true : false,
            onTap: () async {
              Promo? result = await Navigator.of(context)
                  .pushNamed(PromoScreen.routeName) as Promo?;
              if (result != null) {
                setState(() {
                  promo = result;
                  SharedService.setPromo(promo?.price?.toDouble() ?? 1.0);
                });
              }
            },
            child: promo != null
                ? PromoItem(
                    promo: promo,
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        title: 'Warning',
                        titleTextStyle: const TextStyle(color: Colors.black),
                        descTextStyle: const TextStyle(color: Colors.black),
                        desc: 'Are you sure to remove this promo?',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        btnOkOnPress: () {
                          setState(() {
                            promo = null;
                          });
                        },
                      ).show();
                    },
                  )
                : const SizedBox(),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomButton(
              title: 'Payment',
              button: () {
                if (guests.isNotEmpty && seats.isNotEmpty) {
                  if (promo == null) {
                    SharedService.clear("promo");
                  }
                  Navigator.of(context).pushNamed(CheckOutStepFlight.routeName,
                      arguments: {'step': 1, 'flight': widget.flight});
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Error',
                    titleTextStyle: const TextStyle(color: Colors.black),
                    descTextStyle: const TextStyle(color: Colors.black),
                    desc: 'You haven\'t added contact information or seats',
                    buttonsTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: true,
                  ).show();
                }
              })
        ],
      ),
    );
  }
}

class ItemDetailCheckout extends StatelessWidget {
  const ItemDetailCheckout({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0xFF636363)),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}

class ItemSeat extends StatefulWidget {
  const ItemSeat({super.key, required this.flight, required this.seats});

  final FlightModel flight;
  final List<Seat> seats;

  @override
  State<ItemSeat> createState() => _ItemSeatState();
}

class _ItemSeatState extends State<ItemSeat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          widget.seats.length,
          (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: CouponCard(
                height: 100,
                backgroundColor: Colors.grey.withOpacity(0.2),
                curveAxis: Axis.vertical,
                curveRadius: 20,
                clockwise: true,
                firstChild: Container(
                    margin: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppPath.iconSeat,
                          fit: BoxFit.contain,
                          height: 50,
                          width: 50,
                        )
                      ],
                    )),
                secondChild: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Position: ',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: const Color(0xFF636363)),
                          ),
                          Text(
                            widget.seats.isNotEmpty
                                ? widget.seats[index].name ?? ''
                                : '',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: const Color(0xFF636363)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Type: ',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: const Color(0xFF636363)),
                          ),
                          Text(
                            widget.seats.isNotEmpty
                                ? widget.seats[index].type ?? ''
                                : '',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: const Color(0xFF636363)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ItemCheckoutFlight extends StatefulWidget {
  const ItemCheckoutFlight(
      {super.key,
      required this.flight,
      required this.guest,
      required this.seat});

  @override
  State<ItemCheckoutFlight> createState() => _ItemCheckoutFlightState();
  final FlightModel flight;
  final Guest guest;
  final Seat seat;
}

class _ItemCheckoutFlightState extends State<ItemCheckoutFlight> {
  String _formatDate(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
    return 'N/A';
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('h:mm').format(dateTime);
    }
    return 'N/A';
  }

  final Map<String, String> iconAir = {
    'AirAsia': AppPath.iconAsia,
    'LionAir': AppPath.iconLion,
    'BatikAir': AppPath.iconBatik,
    'Garuna': AppPath.iconGaruna,
    'Citilink': AppPath.iconCitilink,
  };

  @override
  Widget build(BuildContext context) {
    return CouponCard(
      height: 420,
      curvePosition: 300,
      backgroundColor: Colors.white,
      firstChild: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  Text(
                    widget.flight.from_place ?? "All",
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Text(
                    widget.flight.from_place ?? "All",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  )
                ],
              ),
              const Text(
                ' — \u{2708} — ',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Column(
                children: [
                  Text(
                    widget.flight.to_place ?? "All",
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Text(widget.flight.to_place ?? "All",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black))
                ],
              ),
            ]),
          ),
          const DashLineWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                iconAir[widget.flight.airline] ?? AppPath.flight,
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
              ItemDetailCheckout(
                  title: 'Airline',
                  content: widget.flight.airline ?? 'Air Asia'),
              ItemDetailCheckout(
                  title: 'Passengers', content: widget.guest.name ?? ''),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ItemDetailCheckout(
                  title: 'Date',
                  content: _formatDate(widget.flight.departure_time)),
              const ItemDetailCheckout(title: 'Gate', content: ''),
              ItemDetailCheckout(
                  title: 'Flight No.', content: widget.flight.no ?? '')
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ItemDetailCheckout(
                title: 'Boarding Time',
                content: _formatTime(widget.flight.departure_time),
              ),
              ItemDetailCheckout(
                  title: 'Seat', content: widget.seat.name ?? ''),
              ItemDetailCheckout(
                  title: 'Class', content: widget.seat.type ?? '')
            ],
          )
        ],
      ),
      secondChild: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          border: DashedBorder(
            dashLength: 15,
            top: BorderSide(color: Color(0xFFE5E5E5)),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '${widget.flight.price}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '/passenger',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
            Text(
              ' passenger',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
