import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/check_out/checkout_step.dart';
import '../../widget/widget.dart';
import 'item_room.dart';

class SelectRoomScreen extends StatefulWidget {
  const SelectRoomScreen({
    super.key,
    required this.rooms,
  });

  static const String routeName = '/select_room';

  final List<RoomModel> rooms;

  @override
  State<SelectRoomScreen> createState() => _SelectRoomScreenState();
}

class _SelectRoomScreenState extends State<SelectRoomScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
      title: 'Select Room',
      isIcon: false,
      showModalBottomSheet: () {},
      child: SingleChildScrollView(
        child: Column(
          children: widget.rooms
              .map(
                (e) => ItemRoomWidget(
                    onTap: () {
                      Navigator.of(context).pushNamed(CheckOutStep.routeName,
                          arguments: {'step': 0, 'room': e});
                    },
                    roomModel: e),
              )
              .toList(),
        ),
      ),
    );
  }
}
