import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out/components/item_checkout/contact_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../../config/shared_preferences.dart';
import '../../../../model/guest_model.dart';
import '../../../../model/promo_model.dart';
import '../../../../widget/widget.dart';
import '../../../room/item_room.dart';
import '../../../screen.dart';
import '../date_item.dart';
import 'promo_item.dart';
import '../item_options.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key, required this.roomModel});
  final RoomModel roomModel;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  Promo? promo;
  String? savedStartDate;
  String? savedEndDate;
  List<String> contactList = SharedService.getListContacts();
  List<Guest> guests = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    savedStartDate = SharedService.getStartDate();
    savedEndDate = SharedService.getEndDate();
    if (contactList.isNotEmpty) {
      guests =
          contactList.map((e) => Guest.fromDocument(json.decode(e))).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');
    DateTime? startDate;
    DateTime? endDate;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ItemRoomWidget(roomModel: widget.roomModel, numberOfRoom: 0),
        BuildItemOption(
          icon: AppPath.user,
          title: 'Contact Details',
          value: 'Add Contact',
          onTap: () async {
            var updatedGuests = await Navigator.of(context).pushNamed(ContactScreen.routeName) as List<Guest>?;
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
                    buttonsTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: true,
                    btnOkOnPress: () {
                      setState(() {
                        guests.remove(e);
                        List<String> contactString = guests.map((e) => jsonEncode(e.toDocument())).toList();
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
          height: 24.0,
        ),
        Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Date',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                              context, SelectDateScreen.routeName,
                              arguments: DateRangePickerSelectionMode.single);
                          if (result != null) {
                            startDate = result as DateTime?;
                            String start = dateFormatter.format(startDate!);
                            if (start != savedStartDate) {
                              setState(() {
                                savedStartDate = start;
                              });
                              SharedService.setStartDate(start);
                            }
                          }
                        },
                        child: DateItem(
                            icon: AppPath.iconCheckIn,
                            title: 'Check-in',
                            date: savedStartDate ?? "No date selected")),
                    GestureDetector(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                              context, SelectDateScreen.routeName,
                              arguments: DateRangePickerSelectionMode.single);
                          if (result != null) {
                            endDate = result as DateTime?;
                            String end = dateFormatter.format(endDate!);
                            if (end != savedEndDate) {
                              setState(() {
                                savedEndDate = end;
                              });
                              SharedService.setEndDate(end);
                            }
                          }
                        },
                        child: DateItem(
                            icon: AppPath.iconCheckOut,
                            title: 'Check-out',
                            date: savedEndDate ?? "No date selected")),
                  ],
                )
              ],
            )),
        const SizedBox(
          height: 24.0,
        ),
        CustomButton(
          title: 'Payment',
          button: () {
           if(guests.isNotEmpty && savedStartDate != null && savedEndDate != null){
             if(promo == null){
               SharedService.clear("promo");
             }
             Navigator.of(context).pushNamed(CheckOutStep.routeName, arguments: {
               'step': 1,
               'room': widget.roomModel
             });
           }
           else{
             AwesomeDialog(
               context: context,
               dialogType: DialogType.error,
               headerAnimationLoop: false,
               animType: AnimType.bottomSlide,
               title: 'Error',
               titleTextStyle: const TextStyle(color: Colors.black),
               descTextStyle: const TextStyle(color: Colors.black),
               desc: 'You haven\'t added contact information or booking dates',
               buttonsTextStyle: const TextStyle(color: Colors.black),
               showCloseIcon: true,
             ).show();
           }
          },
        ),
        const SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
