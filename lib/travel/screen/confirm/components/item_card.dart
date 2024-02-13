import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/config/image_helper.dart';

import '../../screen.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key});

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
                ImageHelper.loadFromAsset(AppPath.iconCard),
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credit / Debit Card',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: const Color(0xFF313131)),
                    ),
                    Text(
                      'Master Card',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(CardScreen.routeName);
              },
              child: Text(
                'Change',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: const Color(0xFF6155CC)),
              ),
            ),
          ],
        )
    );
  }
}
