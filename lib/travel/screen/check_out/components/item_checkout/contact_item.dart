import 'package:flutter/material.dart';

import '../../../../../config/app_path.dart';
import '../../../../../config/image_helper.dart';
import '../../../../model/guest_model.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.onTap, this.guest});

  final VoidCallback onTap;
  final Guest? guest;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageHelper.loadFromAsset(
              AppPath.profile,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guest?.name ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: const Color(0xFF636363)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  guest?.email ?? 'no email',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: const Color(0xFF636363)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  guest?.country ?? 'no country',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: const Color(0xFF636363)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  guest?.phone ?? 'no phone',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: const Color(0xFF636363)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
