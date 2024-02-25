import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/login_screen.dart';
import 'package:flutter_nhu_nguyen/travel/sqlite/database.dart';

import '../../bloc/bloc.dart';
import '../../model/user_model.dart';
import '../../widget/widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late AuthBloc _authBloc;
  String password = '';
  String? email = SharedService.getEmail();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    //getClient();
  }

  void getClient() async {
    var client = await DBOP.getClient();
    if (client != null) {
      setState(() {
        email = client['email']; // Cập nhật name từ dữ liệu DB
        password = client['password'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
      title: 'User Screen',
      isIcon: false,
      isFirst: true,
      showModalBottomSheet: () {},
      child: Column(
        children: [
          Text(
            email ?? 'email is empty',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Colors.black),
          ),
          Text(
            password.isNotEmpty ? password: 'password is empty',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Colors.black),
          ),
          CustomInkwell(
            mainIcon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: "Log out",
            currentHeight: MediaQuery.of(context).size.height,
            onTap: () {
              _authBloc.add(AuthEventLoggedOut());
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
