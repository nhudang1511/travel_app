import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';

import '../../model/room_model.dart';
import '../../widget/widget.dart';

class ItemRoomWidget extends StatelessWidget {
  const ItemRoomWidget({
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
    int? roomSelected = SharedService.getRoom();
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
         if(roomModel.services!.isNotEmpty)
           Wrap(
             spacing: 30,
             children: [
               ...?roomModel.services?.map((e) => ItemUtilityHotelWidget(serviceId: e)),
             ],
           ),
          const DashLineWidget(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${roomModel.price.toString()}',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '/night',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black),
                    )
                  ],
                ),
              ),
              Expanded(
                child: numberOfRoom == null
                    ? GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xff8F67E8), Color(0xff6155CC)],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Choose',
                          ),
                        ),
                      )
                    : Text(
                        roomSelected != null ? '$roomSelected/${roomModel.total} room' :'${roomModel.total} room',
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: Colors.black),
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
