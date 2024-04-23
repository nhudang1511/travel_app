import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/firebase.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/rating/rating_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/hotel_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/rating_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/main_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/write_review/components/item_hotel.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_app_bar.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_appbar_item.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter_nhu_nguyen/config/utils.dart';

import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.hotelModel});

  final HotelModel hotelModel;

  static const String routeName = '/writeReviews';

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  //late RatingBloc _ratingBloc;
  // final reviewBloc = BlocProvider.of<RatingBloc>(context);
  final TextEditingController commentController = TextEditingController();
  int rating = 5;
  List<String> photos = [''];

  Uint8List? _image;
  List<Uint8List>? _images;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //_ratingBloc = BlocProvider.of<RatingBloc>(context);
  }

  Future selectImage() async {
    final pickedFile = await pickImage(ImageSource.gallery);

    setState(() {
      _images ??= [];
      _image = pickedFile;
      _images?.add(_image!);
    });
  }

  Future<String> saveImage(Uint8List imageData) async {
    return await StoreData().uploadImageToStorage(
        "profileImage", imageData.hashCode.toString(), imageData);
  }

  @override
  Widget build(BuildContext context) {
    // _ratingBloc = BlocProvider.of<RatingBloc>(context);
    final _formKey = GlobalKey<FormState>();
    String _textInput = '';
    return CustomAppBarItem(
        title: 'Your Profile',
        isIcon: false,
        isFirst: false,
        showModalBottomSheet: () {},
        child: BlocProvider(
            create: (_) => RatingBloc(RatingRepository()),
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(1.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 5.0,
                        ),
                        ItemHotelR(hotelModel: widget.hotelModel),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.only(bottom: 24.0),
                            child: Column(
                              children: [
                                const Divider(color: Colors.black),
                                Text(
                                  'Rating',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                                RatingBar.builder(
                                  initialRating: rating.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  onRatingUpdate: (rate) {
                                    rating = rate.toInt();
                                  },
                                ),
                                const Divider(color: Colors.black),
                                Text(
                                  'Comment',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                                // Thêm các widget cho việc đánh giá
                                TextFormField(
                                  controller: commentController,
                                  keyboardType: TextInputType.multiline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _textInput = value!;
                                  },
                                  textAlign: TextAlign.start,
                                  maxLength: 200,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    labelText:
                                        'Enter your comment', // Nhãn của ô nhập
                                    hintText:
                                        'Type something...', // Gợi ý cho người dùng
                                    border:
                                        OutlineInputBorder(), // Định dạng viền của ô nhập
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 40.0),
                                    alignLabelWithHint: true,
                                  ),
                                ),

                                const Divider(color: Colors.black),
                                Text(
                                  'Images',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, // Màu của đường viền
                                      width: 0.2, // Độ dày của đường viền
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  height: 100,
                                  width: 400,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        _images != null ? _images!.length : 0,
                                    itemBuilder: (context, index) {
                                      if (_images == null) {
                                        return Text('Not foud');
                                      }
                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: _images != null
                                            ? Image.memory(_images![index])
                                            : Text('No image data available.'),
                                      );
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: selectImage,
                                    child: const Text('Select image')),
                              ],
                            )),
                        ElevatedButton(
                          onPressed: () async {
                            if (_images != null) {
                              for (Uint8List u in _images!) {
                                String image = await saveImage(u);
                                if (photos[0] == '') {
                                  photos[0] = image;
                                } else {
                                  photos.add(image);
                                }
                              }
                            }
                            if (!_formKey.currentState!.validate()) {
                              // Do something with the input data
                              
                            }
                            else{
                            RatingBloc(RatingRepository()).add(AddRating(
                                comment: commentController.text,
                                hotel: widget.hotelModel.id,
                                photos: photos,
                                ratedTime: Timestamp.now(),
                                rates: rating,
                                user: SharedService.getUserId()));
                            Navigator.pushNamedAndRemoveUntil(context,
                                MainScreen.routeName, (route) => false);
                            }
                          },
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  )),
            )));
  }
}
