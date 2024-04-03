import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/hotel_model.dart';

class ItemHotelR extends StatelessWidget {
  final HotelModel hotelModel;
  const ItemHotelR({Key? key, required this.hotelModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
                    width: 5.0,
                  ),
          Container(
            //width: double.infinity,
            width: 100,
            margin: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  16.0,
                ),
                bottomRight: Radius.circular(
                  16.0,
                ),
              ),
              child: Image.network(
                hotelModel.hotelImage ?? "",
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotelModel.hotelName ?? "",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black),
              ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFF77777),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(hotelModel.location ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black)),
                ],
              ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  
                  Text(hotelModel.star.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.black)),
                  Text(' (${hotelModel.numberOfReview} reviews)',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: const Color(0xFF838383))),
                ],
              ),
              Row(
                children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\$${hotelModel.price.toString()}',
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
                ],
              ),
            ],
          )

          // Padding(
          //   padding: const EdgeInsets.all(
          //     16.0,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         hotelModel.hotelName ?? "",
          //         style: Theme.of(context)
          //             .textTheme
          //             .displayMedium
          //             ?.copyWith(color: Colors.black),
          //       ),
          //       const SizedBox(
          //         height: 16.0,
          //       ),
          //       Row(
          //         children: [
          //           const Icon(
          //             Icons.location_on,
          //             color: Color(0xFFF77777),
          //           ),
          //           const SizedBox(
          //             width: 5.0,
          //           ),
          //           Text(hotelModel.location ?? "",
          //               style: Theme.of(context)
          //                   .textTheme
          //                   .bodyLarge
          //                   ?.copyWith(color: Colors.black)),
          //         ],
          //       ),
          //       const SizedBox(
          //         height: 16.0,
          //       ),
          //       Row(
          //         children: [
          //           const Icon(
          //             Icons.star,
          //             color: Colors.yellow,
          //           ),
          //           const SizedBox(width: 5.0),
          //           Text(hotelModel.star.toString(),
          //               style: Theme.of(context)
          //                   .textTheme
          //                   .headlineSmall
          //                   ?.copyWith(color: Colors.black)),
          //           Text(' (${hotelModel.numberOfReview} reviews)',
          //               style: Theme.of(context)
          //                   .textTheme
          //                   .titleLarge
          //                   ?.copyWith(color: const Color(0xFF838383))),
          //         ],
          //       ),
          //       //const DashLineWidget(),
          //       Row(
          //         children: [
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text('\$${hotelModel.price.toString()}',
          //                     style: Theme.of(context)
          //                         .textTheme
          //                         .displayMedium
          //                         ?.copyWith(color: Colors.black)),
          //                 const SizedBox(
          //                   height: 5.0,
          //                 ),
          //                 Text('/night',
          //                     style: Theme.of(context)
          //                         .textTheme
          //                         .bodyMedium
          //                         ?.copyWith(color: Colors.black))
          //               ],
          //             ),
          //           ),

          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
