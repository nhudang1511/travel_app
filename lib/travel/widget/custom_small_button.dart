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
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 155,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
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
          )),
    );
  }
}