import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../config/shared_preferences.dart';
import '../../model/hotel_model.dart';
import '../../widget/widget.dart';

class ItemHotelWidget extends StatefulWidget {
  const ItemHotelWidget({
    Key? key,
    required this.hotelModel,
    this.onTap,
  }) : super(key: key);

  final HotelModel hotelModel;
  final Function()? onTap;

  @override
  State<ItemHotelWidget> createState() => _ItemHotelWidgetState();
}

class _ItemHotelWidgetState extends State<ItemHotelWidget> {
  List<HotelModel> hotelLiked = [];
  List<String> hotelList = SharedService.getLikedHotels();

  @override
  void initState() {
    super.initState();
    if (hotelList.isNotEmpty) {
      hotelLiked = hotelList
          .map((e) => HotelModel().fromDocument(json.decode(e)))
          .toList();
      print(hotelLiked.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(right: 16.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      16.0,
                    ),
                    bottomRight: Radius.circular(
                      16.0,
                    ),
                  ),
                  child: Image.network(
                    widget.hotelModel.hotelImage ?? "",
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: hotelLiked.any(
                            (element) => element.id == widget.hotelModel.id)
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                hotelLiked.removeWhere(
                                        (element) =>
                                    element.id == widget.hotelModel.id);
                              });
                              List<String> hotelString =
                              hotelLiked
                                  .map((e) => jsonEncode(
                                  e.toDocument()))
                                  .toList();
                              SharedService.setLikedPlaces(
                                  hotelString);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                hotelLiked.add(widget.hotelModel);
                              });
                              List<String> hotelString =
                              hotelLiked
                                  .map((e) => jsonEncode(
                                  e.toDocument()))
                                  .toList();
                              SharedService.setLikedHotels(hotelString);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.hotelModel.hotelName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFF77777),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(widget.hotelModel.location ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.black)),
                    // Text(
                    //   ' - ${hotelModel.location_description} from destination',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyMedium
                    //       ?.copyWith(color: const Color(0xFF838383)),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    const SizedBox(width: 5.0),
                    Text(widget.hotelModel.star.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black)),
                    Text(' (${widget.hotelModel.numberOfReview} reviews)',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: const Color(0xFF838383))),
                  ],
                ),
                const DashLineWidget(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${widget.hotelModel.price.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: Colors.black)),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text('/night',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black))
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onTap,
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
                            'Book a room',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
