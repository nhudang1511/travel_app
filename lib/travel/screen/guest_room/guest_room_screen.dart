import 'package:flutter/material.dart';

import '../../../config/app_path.dart';
import '../../../config/shared_preferences.dart';
import '../../widget/widget.dart';
import 'components/item_change_guest_room.dart';

class GuestRoomScreen extends StatefulWidget {
  const GuestRoomScreen({super.key});
  static const String routeName = '/guest';

  @override
  State<GuestRoomScreen> createState() => _GuestRoomScreenState();
}

class _GuestRoomScreenState extends State<GuestRoomScreen> {
  final GlobalKey<ItemChangeGuestAndRoomState> _itemCountGuest =
      GlobalKey<ItemChangeGuestAndRoomState>();

  final GlobalKey<ItemChangeGuestAndRoomState> _itemCountRoom =
      GlobalKey<ItemChangeGuestAndRoomState>();
  @override
  void initState(){
    super.initState();
    SharedService.init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar:
          const CustomAppBar(titlePage: 'Add guest and room', subTitlePage: ''),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            ItemChangeGuestAndRoom(
              key: _itemCountGuest,
              initData: SharedService.getGuest() ?? 1,
              icon: AppPath.iconGuest,
              value: 'Guest',
            ),
            ItemChangeGuestAndRoom(
              key: _itemCountRoom,
              initData: SharedService.getRoom() ?? 1,
              icon: AppPath.iconBed2,
              value: 'Room',
            ),
            const SizedBox(
              height: 16.0,
            ),
            CustomButton(title: 'Done', button: () {
              final Map<String, dynamic> arguments = {
                'guest': _itemCountGuest.currentState!.number,
                'room': _itemCountRoom.currentState!.number
              };
              SharedService.setGuest(_itemCountGuest.currentState!.number);
              SharedService.setRoom(_itemCountRoom.currentState!.number);
              Navigator.of(context).pop(arguments);
            })
          ],
        ),
      ),
    );
  }
}
