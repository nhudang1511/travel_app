import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/widget/dashline.dart';

class ItemTotal extends StatelessWidget {
  const ItemTotal({super.key, required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    const int free = 0;
    int nights = SharedService.getDays() ?? 1;
    int room = SharedService.getRoom() ?? 1;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(bottom: 24.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ItemPrice(
              title: '$nights Night',
              price: '$price / 1 night',
            ),
            const SizedBox(height: 10,),
            const ItemPrice(
              title: 'Taxes and Fees',
              price: '${free == 0 ? 'Free' : free}',
            ),
            const SizedBox(height: 10,),
            ItemPrice(
              title: 'Room number:',
              price: '$room',
            ),
            const DashLineWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.black),
                ),
                Text(
                 '${free + price*nights*room}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.black),
                )
              ],
            )
          ],
        ));
  }
}

class ItemPrice extends StatelessWidget {
  const ItemPrice({
    super.key,
    required this.title,
    required this.price,
  });

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0xFF313131)),
        ),
        Text(
          '$price',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0xFF313131)),
        )
      ],
    );
  }
}
