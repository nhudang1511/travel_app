import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_flight_model.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import '../../../widget/custom_button.dart';
import '../../main_screen.dart';
class BookingFlightItem extends StatefulWidget {
  const BookingFlightItem({super.key, required this.bookingFlightModel});

  static const String routeName = '/item_booking_flight';

  @override
  State<BookingFlightItem> createState() => _BookingFlightItemState();
  final BookingFlightModel bookingFlightModel;
}

class _BookingFlightItemState extends State<BookingFlightItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff8F67E8), Color(0xff6357CC)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: CouponCard(
          curveAxis: Axis.horizontal,
          backgroundColor: Colors.white,
          height: MediaQuery.of(context).size.height - 20,
          firstChild: Center(
            child: Text(
              'Completing\n booking flight',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          secondChild: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
                border: DashedBorder(
                  dashLength: 15,
                  top: BorderSide(color: Color(0xFFE5E5E5)),
                )),
            child: Container(
              margin:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Details Booking',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flight: ${widget.bookingFlightModel.flight}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'TypePayment: ${widget.bookingFlightModel.typePayment}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Email: ${widget.bookingFlightModel.email}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Create at: ${widget.bookingFlightModel.createdAt?.toDate()}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Total price: ${widget.bookingFlightModel.price}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  CustomButton(
                      title: 'Home',
                      button: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, MainScreen.routeName, (route) => false);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}