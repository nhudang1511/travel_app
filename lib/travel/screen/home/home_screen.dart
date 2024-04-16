import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/place_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/places/place_detail_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../../config/app_path.dart';
import '../../../config/shared_preferences.dart';
import '../../bloc/bloc.dart';
import '../../model/notification_model.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PlaceBloc _placeBloc;
  List<PlaceModel> places = [];
  List<PlaceModel> placesLiked = [];
  List<String> placesList = SharedService.getLikedPlaces();
  final firebaseMessaging = FirebaseMessaging.instance;

  NotificationModel? _notificationInfo;
  late int _totalNotifications;
  late NotificationBloc _notificationBloc;

  Future<void> initNotifications() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
      // TODO: handle the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //print('title: ${message.notification?.title}');
        //print('body: ${message.notification?.body}');
       // print(message.sentTime);
        NotificationModel notification = NotificationModel(
            title: message.notification?.title,
            body: message.notification?.body,
            dateTime: Timestamp.fromDate(message.sentTime ?? DateTime.now()),
            userId: SharedService.getUserId());
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          //print('total: $_totalNotifications');
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            //leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 10),
          );
          _notificationBloc
              .add(AddNotification(notification: _notificationInfo!));
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        NotificationModel notification = NotificationModel(
            title: message.notification?.title,
            body: message.notification?.body,
            dateTime: Timestamp.fromDate(message.sentTime ?? DateTime.now()),
            userId: SharedService.getUserId());
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
         // print('total: $_totalNotifications');
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            //leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.greenAccent,
            duration: const Duration(seconds: 10),
          );
          _notificationBloc
              .add(AddNotification(notification: _notificationInfo!));
        }
      });
      //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      //print('User declined or has not accepted permission');
    }
    // final token = await firebaseMessaging.getToken();
    // print('token: $token');
  }

  @override
  void initState() {
    super.initState();
    _placeBloc = PlaceBloc(PlaceRepository())..add(LoadPlace());
    if (placesList.isNotEmpty) {
      placesLiked = placesList
          .map((e) => PlaceModel().fromDocument(json.decode(e)))
          .toList();
    }
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _totalNotifications = 0;
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _placeBloc,
      child: Scaffold(
        appBar: CustomHomeAppBar(
          titlePage: 'Home Screen',
          subTitlePage: 'Where are you going next?',
          totalNotification: _totalNotifications
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CustomChooseButton(
                      title: 'Hotels',
                      color: const Color(0xFFFE9C5E),
                      imgLink: AppPath.icHotel,
                      onTap: () {
                        Navigator.pushNamed(
                            context, BookingHotelScreen.routeName);
                      },
                    ),
                    CustomChooseButton(
                      title: 'Flight',
                      color: const Color(0xFFF77777),
                      imgLink: AppPath.icFlight,
                      onTap: () {
                        Navigator.pushNamed(
                            context, BookingFlightScreen.routeName);
                      },
                    ),
                    CustomChooseButton(
                      title: 'All',
                      color: const Color(0xFF3EC8BC),
                      imgLink: AppPath.icAll,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Popular Destinations',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: const Color(0xFF313131))),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AllPlacesScreen.routeName,
                          arguments: places);
                    },
                    child: Text('See All',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: const Color(0xFF6155CC))),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: BlocBuilder<PlaceBloc, PlaceState>(
                  builder: (context, state) {
                    if (state is PlaceLoaded) {
                      places = state.places;
                      places.sort(
                          (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
                      // print('Places[index] value ${places[0].image}');
                    }

                    return MasonryGridView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: places.length < 5 ? places.length : 4,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.pushNamed(context,
                                            PlaceDetailsScreen.routeName,
                                            arguments: places[index])
                                      },
                                      child: Image.network(
                                        places[index].image ??
                                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: placesLiked.any((element) =>
                                                element.image ==
                                                places[index].image)
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    placesLiked.removeWhere(
                                                        (element) =>
                                                            element.image ==
                                                            places[index]
                                                                .image);
                                                  });
                                                  List<String> placesString =
                                                      placesLiked
                                                          .map((e) => jsonEncode(
                                                              e.toDocument()))
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
                                                        id: places[index].id,
                                                        name:
                                                            places[index].name,
                                                        image:
                                                            places[index].image,
                                                        rating: places[index]
                                                            .rating));
                                                  });
                                                  List<String> placesString =
                                                      placesLiked
                                                          .map((e) => jsonEncode(
                                                              e.toDocument()))
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
                                        child: Text(
                                            places[index].name ?? 'VietNam')),
                                    Positioned(
                                        width: 50,
                                        height: 24,
                                        bottom: 5,
                                        left: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(50),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Color(0xFFFFC107),
                                              ),
                                              Text(
                                                places[index].rating.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     context.read<AuthBloc>().add(AuthEventLoggedOut());
        //     Navigator.pushNamedAndRemoveUntil(
        //         context, LoginScreen.routeName, (route) => false);
        //   },
        // ),
      ),
    );
  }
}

class CustomChooseButton extends StatelessWidget {
  const CustomChooseButton({
    super.key,
    required this.title,
    required this.color,
    required this.imgLink,
    required this.onTap,
  });

  final String title;
  final Color color;
  final String imgLink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: 0.20,
                  child: Container(
                    width: 95,
                    height: 75,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 37,
                  top: 26,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imgLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
