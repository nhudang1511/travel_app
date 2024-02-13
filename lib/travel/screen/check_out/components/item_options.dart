import 'package:flutter/material.dart';
import '../../../../config/image_helper.dart';

class BuildItemOption extends StatelessWidget {
  const BuildItemOption(
      {super.key,
      required this.icon,
      required this.title,
      required this.value,
      required this.onTap,
      this.isChoose = false,
      this.child = const SizedBox()});

  final String icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final Widget child;
  final bool isChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ImageHelper.loadFromAsset(
                    icon,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
              IconButton(
                  onPressed: onTap,
                  icon: isChoose ?  const Icon(
                    Icons.circle,
                    color: Color(0xFFAFA4F8),
                  ) : const Icon(
                    Icons.circle,
                    color: Color(0xFFE0DDF5),
                  )
              )
            ],
          ),
          const SizedBox(
            height: 24.0,
          ),
          child,
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: const Color(0xff6155CC).withOpacity(0.15),
                borderRadius: BorderRadius.circular(
                  40,
                ),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: const Color(0xff6155CC)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
