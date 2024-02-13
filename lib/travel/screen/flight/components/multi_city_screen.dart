import 'package:flutter/material.dart';

import '../../../../config/app_path.dart';
import '../../../../config/image_helper.dart';
import '../../../widget/widget.dart';
import '../../booking_hotel/components/item_booking.dart';

class MultiCityScreen extends StatelessWidget {
  const MultiCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ItemFlight(),
          const SizedBox(height: 20,),
          const ItemFlight(),
          CustomButton(title: 'Search', button: () {})
        ],
      ),
    );
  }
}

class ItemFlight extends StatelessWidget {
  const ItemFlight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flight 1',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 10,),
            ItemOptionsBookingWidget(
              title: 'From',
              value: 'Viet Nam',
              icon: AppPath.iconFlightFrom,
              onTap: () {},
            ),
            ItemOptionsBookingWidget(
              title: 'To',
              value: 'Viet Nam',
              icon: AppPath.iconFlightTo,
              onTap: () {},
            ),
            ItemOptionsBookingWidget(
              title: 'Departure',
              value: 'Select Date',
              icon: AppPath.iconDeparture,
              onTap: () {},
            ),
            ItemOptionsBookingWidget(
              title: 'Passengers',
              value: '1 Passenger',
              icon: AppPath.iconPassengers,
              onTap: () {},
            ),
            ItemOptionsBookingWidget(
              title: 'Class',
              value: 'Economy',
              icon: AppPath.iconClass,
              onTap: () {},
            ),
          ],
        ),
        Positioned(
          top: 90,
          right: 10,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0DDF5),
                shadowColor: Colors.transparent,
                shape: const CircleBorder()),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ImageHelper.loadFromAsset(AppPath.iconArrow),
            ),
          ),
        )
      ],
    );
  }
}
