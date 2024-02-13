import 'package:flutter/material.dart';

class CheckItem extends StatelessWidget {
  const CheckItem({
    super.key,
    required this.checkbox,
    required this.title,
    required this.radius,
    required this.onToggle,
  });

  final bool checkbox;
  final String title;
  final double radius;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xFF313131)),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: const Color(0xFFE0DDF5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)),
              ),
              child: checkbox
                  ? const Icon(
                      Icons.check,
                      color: Color(0xFF6155CC),
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
