import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/model/place_model.dart';
import '../../widget/widget.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.place});

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
                padding:
                    const EdgeInsets.all(8.0), // Add padding around the image
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius to get the desired roundness
                  child: Image.network(
                    widget.place.image ??
                        'https://via.placeholder.com/400', // Placeholder in case the URL is null
                    fit: BoxFit.cover,
                    // You can adjust the width and height as needed, or use constraints to make it responsive
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: placesLiked
                          .any((element) => element.image == widget.place.image)
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              placesLiked.removeWhere((element) =>
                                  element.image == widget.place.image);
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
                              placesLiked.add(PlaceModel(
                                  id: widget.place.id,
                                  name: widget.place.name,
                                  image: widget.place.image,
                                  rating: widget.place.rating));
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
                        )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.place.desc ??
                  'No description available', // Placeholder text in case the description is null
              textAlign: TextAlign.justify,
              style: const TextStyle(
                // Customize your text style
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
