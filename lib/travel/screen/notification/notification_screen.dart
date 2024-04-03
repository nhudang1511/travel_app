import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/repository/notification_repository.dart';

import '../../bloc/bloc.dart';
import '../../model/notification_model.dart';
import '../../widget/widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();

  static const String routeName = '/notification';
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationBloc notificationBloc =
      NotificationBloc(NotificationRepository());
  List<NotificationModel> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => notificationBloc,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar:
              const CustomAppBar(titlePage: 'Notification', subTitlePage: ''),
          body: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              print(SharedService.getUserId());
              if (state is NotificationLoaded) {
                notifications = state.notifications;
              }
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xff6ae792),
                        ),
                        title: Text(
                          'Title ${notifications[index].title}',
                        ),
                        subtitle: Text('Content: ${notifications[index].body}',
                            style: const TextStyle(color: Colors.black)),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                ),
              );
            },
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    notificationBloc
        .add(LoadNotification(uId: SharedService.getUserId() ?? ''));
  }
}
