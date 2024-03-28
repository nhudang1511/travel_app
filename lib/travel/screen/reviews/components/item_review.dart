import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';

class ItemReviewWidget extends StatelessWidget {
  final RatingModel ratingModel;
  const ItemReviewWidget({
    Key? key,
    required this.ratingModel,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          width: 25.14,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AppPath.profile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          children: [
                            Text('James Christin',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text('24 minutes ago',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black))
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                            children: List.generate(
                          5,
                          (index) => Icon(
                            index < ratingModel.rates!.toInt()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                        )),
                      ],
                    )
                    // Expanded(flex: 2,child: Text(ratingModel.comment??''),),
                    // Expanded(flex: 2,child: Text(ratingModel.comment??''),)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(ratingModel.comment ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 20),

            // Image.network(
            //           ratingModel.photos![0] ,
            //           width: double.infinity,
            //           fit: BoxFit.fitWidth,
            //         ),
            //  Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child:
            //       )
            // Row(
            //   children: [
            //     for (var url in ratingModel.photos!)
            //       Padding(
            //           padding: EdgeInsets.all(8.0),
            //           child: Container(
            //             width: 50,
            //             height: 40,
            //             // decoration: BoxDecoration(
            //             //   image: DecorationImage(image: NetworkImage(url))
            //             // ),
            //             // child:
            //             // Image.network(
            //             //   url,
            //             //   // width: double.infinity, // Độ rộng của hình ảnh
            //             //   //height: 100, // Độ cao của hình ảnh
            //             //   fit: BoxFit.fitWidth, // Để hình ảnh lấp đầy kích thước đã cho
            //             // ),
            //           )),
            //   ],
            // )

            SizedBox(
              height: 100,
              // width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: ratingModel.photos!.length,
                itemBuilder: (context, index) {
                  if(ratingModel.photos![index] == '')
                  return Text('Not foud');
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.network(
                      ratingModel.photos![index],
                      //width: 30,
                      // height: 150,
                      //fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
