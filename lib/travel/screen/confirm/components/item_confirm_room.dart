import 'package:flutter/material.dart';

import '../../../../config/app_path.dart';
import '../../../../config/shared_preferences.dart';
import '../../../model/room_model.dart';
import '../../../widget/widget.dart';
import '../../check_out/components/date_item.dart';

class ItemConfirmRoomWidget extends StatelessWidget {
  const ItemConfirmRoomWidget({
    Key? key,
    required this.roomModel,
    this.onTap,
    this.numberOfRoom,
  }) : super(key: key);

  final RoomModel roomModel;
  final Function()? onTap;
  final int? numberOfRoom;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomModel.name ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    roomModel.typePrice ?? "",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Row(
                    children: [
                      Icon(Icons.bed_rounded, color: Color(0xFFFE9C5E),),
                      Text('2 King Bed', style: TextStyle(color: Colors.black),)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  roomModel.image ?? "",
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10,),
          const DashLineWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateItem(icon: AppPath.iconCheckIn, title: 'Check-in', date: SharedService.getStartDate() ?? 'Fri, 13 Feb'),
              DateItem(icon: AppPath.iconCheckOut, title: 'Check-out', date: SharedService.getEndDate() ?? 'Sat, 14 Feb'),
            ],
          )
        ],
      ),
    );
  }
}