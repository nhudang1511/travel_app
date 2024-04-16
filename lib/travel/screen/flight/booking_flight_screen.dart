import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/components/multi_city_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/components/round_trip_screen.dart';
import '../../widget/widget.dart';
import 'components/one_way_screen.dart';

class BookingFlightScreen extends StatefulWidget {
  const BookingFlightScreen({super.key});

  static const String routeName = '/flight';

  @override
  State<BookingFlightScreen> createState() => _BookingFlightScreenState();
}

class _BookingFlightScreenState extends State<BookingFlightScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Book Your Flight',
        subTitlePage: '',
      ),
      body: DefaultTabController(
        length: 3,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const OneWayScreen()
          // Column(
          //   children: <Widget>[
          //     ButtonsTabBar(
          //       backgroundColor: const Color(0xffFE9C5E),
          //       unselectedBackgroundColor: const Color(0xffE0DDF5),
          //       unselectedLabelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xff6022AB)),
          //       labelStyle: Theme.of(context).textTheme.titleLarge,
          //       radius: 20,
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //       height: 50,
          //       tabs: const [
          //         Tab(
          //           text: "One way",
          //         ),
          //         Tab(
          //           text: "Round Trip",
          //         ),
          //         Tab(
          //           text: "Multi-City",
          //         ),
          //       ],
          //     ),
          //     const SizedBox(height: 10,),
          //     const Expanded(
          //       child: TabBarView(
          //         children: <Widget>[
          //           OneWayScreen(),
          //           RoundTripScreen(),
          //           MultiCityScreen()
          //         ],
          //       ),
          //     ),
          //
          //   ],
          // ),
        ),

      ),
    );
  }
}
