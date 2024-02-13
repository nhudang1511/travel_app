import 'package:flutter/material.dart';

import '../../config/app_path.dart';

class ItemUtilityHotelWidget extends StatefulWidget {
  const ItemUtilityHotelWidget({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<ItemUtilityHotelWidget> createState() => _ItemUtilityHotelWidgetState();
}

class _ItemUtilityHotelWidgetState extends State<ItemUtilityHotelWidget> {
  Text buildServiceTitle(String serviceId) {
    final String title;
    switch (serviceId) {
      case "24_HOURS_FRONT_DESK":
        title = "24-hour\nFront Desk";
      case "CURRENCY_EXCHANGE":
        title = "Currency\nExchange";
      case "FREE_BREAKFAST":
        title = "Free\nBreakfast";
      case "FREE_WIFI":
        title = "Free\nWifi";
      case "NON_REFUNDABLE":
        title = "Non-\nRefundable";
      case "NON_SMOKING":
        title = "Non-\nSmoking";
      case "RESTAURENT":
        title = "Restaurant";
      default:
        title = "Restaurant";
    }
    return Text(
      title,
      textAlign: TextAlign.center,
      style:
          Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
    );
  }

  Image buildServiceImage(String serviceId) {
    final String assetPath;
    switch (serviceId) {
      case "24_HOURS_FRONT_DESK":
        assetPath = AppPath.iconFrontDesk;
      case "CURRENCY_EXCHANGE":
        assetPath = AppPath.iconExchange2;
      case "FREE_BREAKFAST":
        assetPath = AppPath.iconFree;
      case "FREE_WIFI":
        assetPath = AppPath.iconWifi;
      case "NON_REFUNDABLE":
        assetPath = AppPath.iconNonRefund;
      case "NON_SMOKING":
        assetPath = AppPath.iconNonSmoking;
      case "RESTAURENT":
        assetPath = AppPath.iconRestaurant;
      default:
        assetPath = AppPath.iconRestaurant;
    }
    return Image.asset(
      assetPath,
      width: 32,
      height: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildServiceImage(widget.serviceId),
        const SizedBox(
          height: 8.0,
        ),
        buildServiceTitle(widget.serviceId),
      ],
    );
  }
}
