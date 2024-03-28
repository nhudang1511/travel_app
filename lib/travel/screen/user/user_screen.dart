import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/login_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/user/user_edit_screen.dart';
import '../../bloc/bloc.dart';
import '../../widget/widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late AuthBloc _authBloc;
  String? email = SharedService.getEmail();
  String? name = SharedService.getName();
  String? phone = SharedService.getPhone();
  String? country = SharedService.getCountry();
  String? avatar = SharedService.getAvatar();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
      title: 'User Screen',
      isIcon: false,
      isFirst: true,
      showModalBottomSheet: () {},
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 53,
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  child: (avatar != "" && avatar != null) ?
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatar!),
                    radius: 50,
                  ) : const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: ClipOval(
                      child: Icon(
                        Icons.person, size: 80, color: Color(0xFF8F67E8),),
                    ),
                  ),
                ),
                //name
                Text(
                  name ?? 'no name',
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.black),
                ),
                //mail
                Text(
                  email ?? 'no email',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: CustomButton(
                title: "Edit profile",
                button: () {
                  Navigator.pushNamed(context, UserEditScreen.routeName);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                      ),
                    ),
                  ),
                  //settings
                  CustomInkwell(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      mainIcon: Icon(
                        Icons.settings,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                      title: "Settings",
                      currentHeight: MediaQuery
                          .of(context)
                          .size
                          .height),
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: Container(
                      height: 0.5,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                      ),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomInkwell(
                          onTap: () {
                            if (state is AuthenticateState) {
                              _authBloc.add(AuthEventLoggedOut());
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            }
                          },
                          mainIcon: Icon(
                            Icons.logout,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                          ),
                          title: "Log out",
                          currentHeight: MediaQuery
                              .of(context)
                              .size
                              .height);
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
