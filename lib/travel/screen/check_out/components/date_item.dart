import 'package:flutter/material.dart';

import '../../../../config/image_helper.dart';

class DateItem extends StatelessWidget {
  const DateItem({
    super.key, required this.icon, required this.title, required this.date,
  });
  final String icon;
  final String title;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageHelper.loadFromAsset(
          icon,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: const Color(0xFF636363)),
            ),
            const SizedBox(height: 5,),
            Text(
              date,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}