import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme/dark_theme.dart';
import '../../../config/theme/theme_provider.dart';
import '../../widget/widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static const String routeName = '/settings';

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        appBar: const CustomAppBar(
          titlePage: 'Settings',
          subTitlePage: '',
          isFirst: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 32, left: 32, top: 32),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.nightlight,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Dark mode",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: Provider.of<ThemeProvider>(context).themeData == darkTheme,
                            onChanged: (bool value) {
                              Provider.of<ThemeProvider>(context, listen:  false).toggleTheme();
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
