import 'package:flutter/material.dart';

class CustomDriver extends StatelessWidget {
  const CustomDriver({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 3,
          color: Colors.black,
        ),
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xFF313131))),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 3,
          color: Colors.black,
        ),
      ],
    );
  }
}
