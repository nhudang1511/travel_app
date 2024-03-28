import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';
import 'package:flutter_nhu_nguyen/travel/repository/place_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/booking_flight_screen.dart';

import '../../config/app_path.dart';
import '../../config/image_helper.dart';
import '../bloc/place/place_bloc.dart';
import '../model/place_model.dart';
import '../screen/places/place_detail_screen.dart';

class CustomHomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({
    super.key,
    required this.titlePage,
    required this.subTitlePage,
  });

  final String titlePage;
  final String subTitlePage;

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(200.0);
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  late PlaceBloc _placeBloc;
  String? avatar = SharedService.getAvatar();

  @override
  void initState() {
    super.initState();
    _placeBloc = PlaceBloc(PlaceRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _placeBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200.0),
          child: AppBar(
            title: Center(
              child: Column(
                children: [
                  Text(widget.titlePage,
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 15),
                  Text(widget.subTitlePage,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications)),
              Container(
                margin: const EdgeInsets.only(top: 70, right: 10),
                width: 45,
                height: 45,
                child: Stack(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ( avatar != "") ?
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(avatar!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ) :
                    Positioned(
                      left: 10.43,
                      top: 5,
                      child: Container(
                        width: 25.14,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppPath.profile),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
            toolbarHeight: 200,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Stack(
              fit: StackFit.loose,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff8F67E8), Color(0xff6357CC)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ImageHelper.loadFromAsset(
                          'assets/images/ico_oval_top.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ImageHelper.loadFromAsset(
                        'assets/images/ico_oval_bottom.png',
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: const Alignment(0.0, 1.10),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 14.5,
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20.0,
                            spreadRadius: .5,
                            offset: Offset(
                              0.0,
                              5.0,
                            ),
                          )
                        ],
                      ),
                      child: TextField(
                        onSubmitted: (submittedText) {},
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black38,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Search your destination',
                            hintStyle: Theme.of(context).textTheme.bodyLarge),
                        // onChanged: (value) {
                        //   _placeBloc.add(SearchPlace(name: value));
                        // },
                        // onChanged: (value) {
                        //   showSearch<String>(
                        //   context: context,
                        //   delegate: CustomDelegate(_placeBloc as PlaceLoaded),
                        // );
                        // },
                        readOnly: true,
                        onTap: () {
                          final state = BlocProvider.of<PlaceBloc>(context).state;
                          if (state is PlaceLoaded) {
                              showSearch<String>(
                                context: context,
                                delegate: CustomDelegate(state),
                              );
                            }
                        }
                      ),
                    ),
                  ),
                ),
                BlocBuilder<PlaceBloc, PlaceState>(
                  builder: (context, state) {
                    if (state is PlaceLoaded) {
                      return Align(
                        alignment: const Alignment(0.0, 5),
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: ListView.builder(
                                itemCount: state.places.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Image.network(
                                      state.places[index].image ??
                                          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    title: Text(
                                        state.places[index].name ?? 'null',
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  );
                                },
                              )),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CustomDelegate extends SearchDelegate<String> {
  final PlaceLoaded state;

  CustomDelegate(this.state);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff8F67E8),
      )
        // Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Color(0xff8F67E8), Color(0xff6357CC)],
        //     ),
        //     borderRadius: BorderRadius.only(
        //       bottomLeft: Radius.circular(35),
        //     ),
        //   ),
        // ),
    );
    return theme;
  }
  

  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {

    List<PlaceModel> places =state.places;
    var listToShow;
    if (query.isNotEmpty) {
      listToShow = places.where((places) {return places.name!.toLowerCase().contains(query.toLowerCase());}).toList();
    } else {
      listToShow = places;
    }
    return ListView.builder(
        itemCount: listToShow.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 55,vertical: 5),
            child: ListTile(
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black26),borderRadius: BorderRadius.circular(5)),

              leading: Image.network(
                listToShow[index].image ??
                    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                width: 70,
                height: 70,
                fit: BoxFit.fitHeight,
              ),
              title: Text(
                  listToShow[index].name ?? 'null',
                  style: const TextStyle(
                      color: Colors.black)),
              onTap: ()=>Navigator.pushNamed(context,
                  PlaceDetailsScreen.routeName,
                  arguments: listToShow[index]),
            ),
          );
        },
        
      );
  }
}