import 'package:flutter/material.dart';

class CustomButton2 extends StatelessWidget {
  const CustomButton2({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.71, -0.71),
          end: const Alignment(-0.71, 0.71),
          colors: [
            const Color(0xFF8862E4).withOpacity(0.10),
            const Color(0xFF6657CF).withOpacity(0.10)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: const Color(0xFF6155CC)))),
    );
  }
}
