import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/config/image_helper.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';

import '../../screen.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String? paymentMethod;


  @override
  void initState() {
    super.initState();
    paymentMethod = SharedService.getTypePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(bottom: 24.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageHelper.loadFromAsset(paymentMethod == 'card'
                    ? AppPath.iconCard
                    : AppPath.iconBank),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  paymentMethod ?? 'null',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ],
        ));
  }
}
