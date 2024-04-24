import 'package:flutter/material.dart';

import '../../widget/custom_app_bar.dart';

class StatisticalScreen extends StatefulWidget {
  const StatisticalScreen({super.key});

  static const String routeName = '/statistical';

  @override
  State<StatisticalScreen> createState() => _StatisticalScreenState();
}

class _StatisticalScreenState extends State<StatisticalScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          titlePage: 'Statistical',
          subTitlePage: '',
          isFirst: true,
        ),
        body: Column(

    ));
  }
}

