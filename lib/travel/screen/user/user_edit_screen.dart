import 'package:flutter/material.dart';

import '../../widget/custom_appbar_item.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({Key? key}) : super(key: key);
  static const String routeName = '/edit_profile';
  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(
      title: 'User Edit Screen',
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
                  child: const CircleAvatar(
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
                  Navigator.pushNamed(context, "/edit_profile");
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
