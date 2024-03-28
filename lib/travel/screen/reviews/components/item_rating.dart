import 'package:flutter/material.dart';

class ItemRatingRoomWidget extends StatelessWidget {
  final List<int> rating;
  final int starRating = 5;

  const ItemRatingRoomWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

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
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16.0,
                    ),
                    Text('4.8',
                        style: TextStyle(
                            fontSize: 46,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text('of 5',
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    Text('(30 Reviews)',
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            starRating,
                            (indexColumn) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    starRating,
                                    (indexRow) => Row(
                                          children: [
                                            if (indexRow == 0)
                                               Column(
                                                children: [
                                                  Text(rating[4-indexColumn].toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                  const SizedBox(
                                                    width: 40.0,
                                                  ),
                                                ],
                                              ),
                                            Icon(
                                              indexRow <
                                                      starRating - indexColumn
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                            ),
                                          ],
                                        ))),
                          )))),
            ],
          )
        ],
        // children: [
        //   Text('4.8fsafasfsssssssssssssss',style: Theme.of(context).textTheme.displayMedium),
        // ],
        // mainAxisSize: MainAxisSize.min,
        // children: List.generate(
        //   5,
        //   (index) => Icon(
        //     index < rating ? Icons.star : Icons.star_border,
        //     color: Colors.amber,
        //   ),
        // ),
      ),
    );
  }
}
