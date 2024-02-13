import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/filght_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out_flight/components/confirm_flight_screen.dart';
import '../../widget/custom_appbar_item.dart';
import '../payment/payment_screen.dart';
import 'components/check_out_screen_flight.dart';

class CheckOutStepFlight extends StatefulWidget {
  const CheckOutStepFlight({super.key, required this.step, required this.flightModel});
  static const String routeName = '/checkoutstep_flight';
  final int step;
  final FlightModel flightModel;

  @override
  State<CheckOutStepFlight> createState() => _CheckOutStepFlightState();
}

class _CheckOutStepFlightState extends State<CheckOutStepFlight> {
  late final List<String> steps;
  late final List<Widget> screens;
  Widget buildItemCheckOutStepFlight(
      int step,
      String nameStep,
      bool isEnd,
      bool isCheck,
      ) {
    return Row(
      children: [
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: isCheck ? Colors.white : Colors.white.withOpacity(0.1),
          ),
          alignment: Alignment.center,
          child: Text(
            step.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isCheck ? Colors.black : Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(nameStep, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(
          width: 5,
        ),
        if (!isEnd)
          const SizedBox(
            width: 16.0,
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.white,
            ),
          ),
        if (!isEnd)
          const SizedBox(
            width: 5,
          ),
      ],
    );
  }
  @override
  void initState(){
    super.initState();
    steps = [
      'Book and Review',
      'Payment',
      'Confirm',
    ];
    screens = [
      CheckOutScreenFlight(flight: widget.flightModel),
      PaymentScreen(model: widget.flightModel,),
      ConfirmFlightScreen(flightModel: widget.flightModel)
    ];
  }
  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
      title: 'Checkout',
      isIcon: false,
      showModalBottomSheet: () {},
      child: Column(
        children: [
          Row(
            children: steps
                .map((e) => buildItemCheckOutStepFlight(
                steps.indexOf(e) + 1,
                e,
                steps.indexOf(e) == steps.length - 1,
                steps.indexOf(e) == widget.step))
                .toList(),
          ),
          screens[widget.step]
        ],
      ),
    );
  }
}
