import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/room/select_room.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/room/room_bloc.dart';
import '../../model/hotel_model.dart';
import '../../model/room_model.dart';
import '../../widget/widget.dart';

class DetailHotelScreen extends StatefulWidget {
  const DetailHotelScreen({super.key, required this.hotelModel});

  static const String routeName = '/detail_hotel_screen';

  final HotelModel hotelModel;

  @override
  State<DetailHotelScreen> createState() => _DetailHotelScreenState();
}

class _DetailHotelScreenState extends State<DetailHotelScreen> {
  late RoomBloc _roomBloc;
  List<RoomModel> rooms = [];

  @override
  void initState() {
    super.initState();
    int guest = SharedService.getGuest() ?? 1;
    int room = SharedService.getRoom() ?? 1;
    _roomBloc = RoomBloc(RoomRepository())
      ..add(LoadRoomByHotelIdGuestRoom(widget.hotelModel.id ?? '', guest, room));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
              child: ClipRRect(
            child: Image.network(
              widget.hotelModel.hotelImage ?? "",
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          )),
          Positioned(
            top: 24.0 * 3,
            left: 24.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 24.0 * 3,
            right: 24.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  FontAwesomeIcons.solidHeart,
                  size: 16.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => _roomBloc,
            child: DraggableScrollableSheet(
              initialChildSize: 0.3,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0 * 2),
                      topRight: Radius.circular(16.0 * 2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          height: 5,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.hotelModel.hotelName ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${widget.hotelModel.price}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      ' /night',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      widget.hotelModel.location ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const DashLineWidget(),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFC107),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '${widget.hotelModel.star}/5',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      ' (${widget.hotelModel.numberOfReview} reviews)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              color: const Color(0xFF838383)),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'See All',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              color: const Color(0xff6155CC)),
                                    ),
                                  ],
                                ),
                                const DashLineWidget(),
                                Text(
                                  'Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  widget.hotelModel.information ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.black),
                                ),
                                BlocBuilder<RoomBloc, RoomState>(
                                  builder: (context, state) {
                                    if (state is RoomLoaded) {
                                      rooms = state.rooms;
                                      final Set<String> services = <String>{};
                                      for (var room in rooms) {
                                        services.addAll(room.services ?? []);
                                      }
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Wrap(
                                          spacing: 30,
                                          children: [
                                            ...services.map((e) =>
                                                ItemUtilityHotelWidget(
                                                    serviceId: e)),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  'Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  widget.hotelModel.location_description ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                ClipRRect(
                                  child: Image.asset(
                                    'assets/images/image_map.png',
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 24.0,
                                ),
                                CustomButton(
                                  title: 'Select Room',
                                  button: () {
                                    print(widget.hotelModel.id);
                                    Navigator.pushNamed(
                                        context, SelectRoomScreen.routeName,
                                        arguments: rooms);
                                  },
                                ),
                                const SizedBox(
                                  height: 24.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
