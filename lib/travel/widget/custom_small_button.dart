import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  const CustomSmallButton({
    super.key,
    required this.title,
    required this.imgLink,
    required this.color,
    required this.colorText, required this.onPressed,
  });

  final String title;
  final String imgLink;
  final Color color;
  final Color colorText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: 155,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: Image.asset(
                  imgLink,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyle(
                color: colorText,
                fontSize: 16,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}