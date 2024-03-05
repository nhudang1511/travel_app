import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.button,
  });

  final String title;
  final VoidCallback button;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        button();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFF8F67E8), Color(0xFF6357CC)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Center(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
      ),
    );
  }
}
