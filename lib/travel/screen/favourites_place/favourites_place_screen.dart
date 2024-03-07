import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/place_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../config/shared_preferences.dart';
import '../../widget/widget.dart';

class FavouritesPlaceScreen extends StatefulWidget {
  const FavouritesPlaceScreen({super.key});

  @override
  State<FavouritesPlaceScreen> createState() => _FavouritesPlaceScreenState();
}

class _FavouritesPlaceScreenState extends State<FavouritesPlaceScreen> {
  List<PlaceModel> placesLiked = List.empty(growable: true);
  List<String> placesLikedString = SharedService.getLikedPlaces();
  @override
  void initState(){
    super.initState();
    if(placesLikedString.isNotEmpty){
      placesLiked = placesLikedString.map((e) => PlaceModel().fromDocument(json.decode(e))).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Favourites Place',
        subTitlePage: '',
        isFirst: true,
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
                  childCount: placesLiked.length,
                      (context, index) => Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          placesLiked[index].image ??
                              'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                             setState(() {
                               placesLiked.removeAt(index);
                               List<String> placesString = placesLiked.map((e) => jsonEncode(e.toDocument())).toList();
                               SharedService.setLikedPlaces(placesString);
                             });
                            },
                            icon: const Icon(Icons.favorite,
                                color: Colors.redAccent)),
                      ),
                      Positioned(
                          left: 10,
                          bottom: 30,
                          child: Text(placesLiked[index].name ?? 'VietNam')),
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
                                  placesLiked[index].rating.toString(),
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
      ),
    );
  }
}
