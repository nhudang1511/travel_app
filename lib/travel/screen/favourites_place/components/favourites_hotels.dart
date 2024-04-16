import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../config/shared_preferences.dart';
import '../../../model/hotel_model.dart';

class FavouriteHotels extends StatefulWidget {
  const FavouriteHotels({super.key});

  @override
  State<FavouriteHotels> createState() => _FavouriteHotelsState();
}

class _FavouriteHotelsState extends State<FavouriteHotels> {
  List<HotelModel> hotelsLiked = List.empty(growable: true);
  List<String> hotelsLikedString = SharedService.getLikedHotels();
  @override
  void initState(){
    super.initState();
    if(hotelsLikedString.isNotEmpty){
      hotelsLiked = hotelsLikedString.map((e) => HotelModel().fromDocument(json.decode(e))).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
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
                childCount: hotelsLiked.length,
                    (context, index) => Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        hotelsLiked[index].hotelImage ??
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
                              hotelsLiked.removeAt(index);
                              List<String> hotelString = hotelsLiked.map((e) => jsonEncode(e.toDocument())).toList();
                              SharedService.setLikedHotels(hotelString);
                            });
                          },
                          icon: const Icon(Icons.favorite,
                              color: Colors.redAccent)),
                    ),
                    Positioned(
                        left: 10,
                        bottom: 30,
                        child: Text(hotelsLiked[index].hotelName ?? '')),
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
                                hotelsLiked[index].star.toString(),
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
    );
  }
}
