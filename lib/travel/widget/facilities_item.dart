import 'package:flutter/material.dart';

class FacilitiesItem extends StatefulWidget {
  const FacilitiesItem({
    super.key,
    required this.checkbox,
    required this.title,
    required this.radius,
    required this.img,
    required this.onToggle,
  });

  final bool checkbox;
  final String title;
  final double radius;
  final String img;
  final VoidCallback onToggle;

  @override
  State<FacilitiesItem> createState() => _FacilitiesItemState();
}

class _FacilitiesItemState extends State<FacilitiesItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(widget.img),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: const Color(0xFF313131)),
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: const Color(0xFFE0DDF5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.radius)),
              ),
              child: widget.checkbox
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