import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/filght_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/card/card_screen.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import '../../../config/app_path.dart';
import '../../../config/image_helper.dart';
import '../../../config/shared_preferences.dart';
import '../../model/card_model.dart';
import '../../widget/widget.dart';
import '../check_out/checkout_step.dart';
import '../check_out/components/item_options.dart';
import '../check_out_flight/checkout_step_flight.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.model});

  final CustomModel model;
  static const String routeName = '/payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CardModel? card;
  String typePayment = "Bank Transfer";
  String? cardString = SharedService.getCard();

  @override
  void initState() {
    super.initState();
    if (cardString != null) {
     card = CardModel.fromDocument(json.decode(cardString!));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildItemOptionsPayment(
        String icon, String title, VoidCallback onTap, bool isChoose) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ImageHelper.loadFromAsset(
                    icon,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
              isChoose
                  ? const Icon(
                      Icons.circle,
                      color: Color(0xFFAFA4F8),
                    )
                  : const Icon(
                      Icons.circle,
                      color: Color(0xFFE0DDF5),
                    )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(
          height: 24.0,
        ),
        buildItemOptionsPayment(
            AppPath.iconCard, 'Card', () {
          setState(() {
            typePayment = "Card";
          });

        }, typePayment == "Card"),
        const SizedBox(
          height: 24.0,
        ),
        buildItemOptionsPayment(
            AppPath.iconBank, 'Bank Transfer', () {
          setState(() {
            typePayment = "Bank Transfer";
          });
          
        }, typePayment == "Bank Transfer"),
        const SizedBox(
          height: 24.0,
        ),
        CustomButton(
          title: 'Done',
          button: () {
            SharedService.setTypePayment(typePayment);
            if(widget.model is RoomModel){
              Navigator.of(context).pushNamed(CheckOutStep.routeName,
                  arguments: {'step': 2, 'room': widget.model});
            }
            else if (widget.model is FlightModel){
              Navigator.of(context).pushNamed(CheckOutStepFlight.routeName,
                  arguments: {'step': 2, 'flight': widget.model});
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
