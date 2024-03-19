import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/model/place_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/booking_flight_screen.dart';
import '../../widget/widget.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({Key? key, required this.place}) : super(key: key);

  final PlaceModel place;
  static const String routeName = '/place-detail';

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  List<PlaceModel> placesLiked = [];
  List<String> placesList = SharedService.getLikedPlaces();
  @override
  void initState() {
    super.initState();
    if (placesList.isNotEmpty) {
      placesLiked = placesList
          .map((e) => PlaceModel().fromDocument(json.decode(e)))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(
        titlePage: widget.place.name ?? '',
        subTitlePage: '',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.place.image ?? 'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: placesLiked.any(
                  (element) => element.image == widget.place.image,
                )
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            placesLiked.removeWhere(
                              (element) => element.image == widget.place.image,
                            );
                          });
                          List<String> placesString = placesLiked
                              .map((e) => jsonEncode(e.toDocument()))
                              .toList();
                          SharedService.setLikedPlaces(placesString);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            placesLiked.add(
                              PlaceModel(
                                id: widget.place.id,
                                name: widget.place.name,
                                image: widget.place.image,
                                rating: widget.place.rating,
                              ),
                            );
                          });
                          List<String> placesString = placesLiked
                              .map((e) => jsonEncode(e.toDocument()))
                              .toList();
                          SharedService.setLikedPlaces(placesString);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
              ),
              Positioned(
                  width: 50,
                  height: 24,
                  bottom: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFC107),
                        ),
                        Text(
                          widget.place.rating.toString(),
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 12.0),
            child: Text(
              widget.place.desc ?? 'No description available',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          // Render the rating text with star icons

          // Add a button below the description text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, BookingFlightScreen.routeName,
                      arguments: widget.place.name);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Pill-like shape
                  ),
                ),
                child: const Text('Book a flight'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
