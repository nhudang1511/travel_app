import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/favourites_place/components/favourites_hotels.dart';
import '../../widget/widget.dart';
import 'components/favourites_places.dart';

class FavouritesPlaceScreen extends StatefulWidget {
  const FavouritesPlaceScreen({super.key});

  @override
  State<FavouritesPlaceScreen> createState() => _FavouritesPlaceScreenState();
}

class _FavouritesPlaceScreenState extends State<FavouritesPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Favourites',
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
                    text: "Places",
                  ),
                  Tab(
                    text: "Hotels",
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    FavouritePlaces(),
                    FavouriteHotels(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

