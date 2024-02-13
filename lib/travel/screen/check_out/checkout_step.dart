import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/screen.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_appbar_item.dart';

class CheckOutStep extends StatefulWidget {
  const CheckOutStep({super.key, required this.step, required this.roomModel});
  static const String routeName = '/checkoutstep';
  final int step;
  final RoomModel roomModel;

  @override
  State<CheckOutStep> createState() => _CheckOutStepState();
}

class _CheckOutStepState extends State<CheckOutStep> {
  late final List<String> steps;
  late final List<Widget> screens;
  Widget buildItemCheckOutStep(
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
    steps  = [
      'Book and Review',
      'Payment',
      'Confirm',
    ];
    screens = [
      CheckOutScreen(roomModel: widget.roomModel,),
      PaymentScreen(model: widget.roomModel,),
      ConfirmScreen(roomModel: widget.roomModel,)
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
                .map((e) => buildItemCheckOutStep(
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
