import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/statistical/components/booking_hotel_statistical.dart';
import '../../widget/custom_app_bar.dart';
import 'components/booking_flight_statistical.dart';

class StatisticalScreen extends StatefulWidget {
  const StatisticalScreen({super.key});

  static const String routeName = '/statistical';

  @override
  State<StatisticalScreen> createState() => _StatisticalScreenState();
}

class _StatisticalScreenState extends State<StatisticalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          titlePage: 'Statistical',
          subTitlePage: '',
          isFirst: true,
        ),
        body: DefaultTabController(
          length: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  backgroundColor: const Color(0xffFE9C5E),
                  unselectedBackgroundColor: const Color(0xffE0DDF5),
                  unselectedLabelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xff6022AB)),
                  labelStyle: Theme.of(context).textTheme.titleLarge,
                  radius: 20,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  tabs: const [
                    Tab(
                      text: "Booking Hotel",
                    ),
                    Tab(
                      text: "Booking Flight",
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      BookingHotelStatistical(),
                      BookingFlightStatistical()
                    ],
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}

