import 'package:flutter/material.dart';

import '../../../../config/app_path.dart';
import '../../../../config/image_helper.dart';
import '../../../widget/widget.dart';
import '../../booking_hotel/components/item_booking.dart';

class RoundTripScreen extends StatelessWidget {
  const RoundTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              ItemOptionsBookingWidget(
                title: 'From',
                value: 'Viet Nam',
                icon: AppPath.iconFlightFrom,
                onTap: () {
                },
              ),
              ItemOptionsBookingWidget(
                title: 'To',
                value: 'Viet Nam',
                icon: AppPath.iconFlightTo,
                onTap: () {
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Departure',
                value: 'Select Date',
                icon: AppPath.iconDeparture,
                onTap: () {
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Return',
                value: 'Select Date',
                icon: AppPath.iconDeparture,
                onTap: () {
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Passengers',
                value: '1 Passenger',
                icon: AppPath.iconPassengers,
                onTap: () {
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Class',
                value: 'Economy',
                icon: AppPath.iconClass,
                onTap: () {
                },
              ),
              CustomButton(title: 'Search', button: (){})
            ],
          ),
          Positioned(
            top: 60,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0DDF5),
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder()
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ImageHelper.loadFromAsset(AppPath.iconArrow),
              ),),
          )
        ],
      ),
    );
  }
}
