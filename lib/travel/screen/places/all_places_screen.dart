import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/shared_preferences.dart';
import '../../model/place_model.dart';
import '../../widget/widget.dart';

class AllPlacesScreen extends StatefulWidget {
  const AllPlacesScreen({super.key, required this.places});

  final List<PlaceModel> places;
  static const String routeName = '/places';

  @override
  State<AllPlacesScreen> createState() => _AllPlacesScreenState();
}

class _AllPlacesScreenState extends State<AllPlacesScreen> {
  List<PlaceModel> placesLiked = [];
  List<String> placesList = SharedService.getLikedPlaces();

  @override
  void initState() {
    super.initState();
    if (placesList.isNotEmpty) {
      placesLiked = placesList
          .map((e) => PlaceModel(id: "").fromDocument(json.decode(e), ""))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          titlePage: 'All Places',
          subTitlePage: '',
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.custom(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      const QuiltedGridTile(2, 1),
                      const QuiltedGridTile(1, 1),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    childCount: widget.places.length,
                    (context, index) => Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.places[index].image ??
                                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: placesLiked.any((element) =>
                                    element.image == widget.places[index].image)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        placesLiked.removeWhere((element) =>
                                            element.image ==
                                            widget.places[index].image);
                                      });
                                      List<String> placesString = placesLiked
                                          .map(
                                              (e) => jsonEncode(e.toDocument()))
                                          .toList();
                                      SharedService.setLikedPlaces(
                                          placesString);
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
                                            id: widget.places[index].id,
                                            name: widget.places[index].name,
                                            image: widget.places[index].image,
                                            rating: widget.places[index].rating));
                                      });
                                      List<String> placesString = placesLiked
                                          .map(
                                              (e) => jsonEncode(e.toDocument()))
                                          .toList();
                                      SharedService.setLikedPlaces(
                                          placesString);
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                  )),
                        Positioned(
                            left: 10,
                            bottom: 30,
                            child:
                                Text(widget.places[index].name ?? 'VietNam')),
                        Positioned(
                            width: 50,
                            height: 24,
                            bottom: 5,
                            left: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(50),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFFFC107),
                                  ),
                                  Text(
                                    widget.places[index].rating.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }
}
