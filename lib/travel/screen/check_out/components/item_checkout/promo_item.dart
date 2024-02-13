import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import '../../../../model/promo_model.dart';
class PromoItem extends StatelessWidget {
  const PromoItem({super.key, required this.promo, required this.onTap});

  final Promo? promo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: CouponCard(
          height: 100,
          backgroundColor: Colors.grey.withOpacity(0.2),
          curveAxis: Axis.vertical,
          curveRadius: 20,
          clockwise: true,
          firstChild: Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Image.network(
                    promo?.image ??
                        'https://cdn-icons-png.flaticon.com/128/6188/6188570.png',
                    fit: BoxFit.contain,
                    height: 75,
                    width: 75,
                  )
                ],
              )),
          secondChild: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Code: ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: const Color(0xFF636363)),
                    ),
                    Text(
                      promo?.code ?? 'no code',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: const Color(0xFF636363)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Endow: ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: const Color(0xFF636363)),
                    ),
                    Text(
                      promo?.endow ?? 'no endow',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: const Color(0xFF636363)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Price: ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: const Color(0xFF636363)),
                    ),
                    Text(
                      promo?.price.toString() ?? 'no price',
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
        ),
      ),
    );
  }
}