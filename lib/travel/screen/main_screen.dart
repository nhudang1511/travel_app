import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nhu_nguyen/travel/screen/screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = '/main';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;
  final List<Widget> pages = [
    const HomeScreen(),
    const FavouritesPlaceScreen(),
    const BriefcaseScreen(),
    const UserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: const Color(0xFF6155CC),
              unselectedColor: const Color(0xFFE0DDF5)),

          /// Likes
          SalomonBottomBarItem(
              icon: const Icon(Icons.favorite),
              title: const Text("Likes"),
              selectedColor: const Color(0xFF6155CC),
              unselectedColor: const Color(0xFFE0DDF5)),

          /// Briefcase
          SalomonBottomBarItem(
              icon: const Icon(
                CupertinoIcons.briefcase_fill,
              ),
              title: const Text("Briefcase"),
              selectedColor: const Color(0xFF6155CC),
              unselectedColor: const Color(0xFFE0DDF5)),

          /// Profile
          SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: const Color(0xFF6155CC),
              unselectedColor: const Color(0xFFE0DDF5)),
        ],
      ),
    );
  }
}

class CustomChooseButton extends StatelessWidget {
  const CustomChooseButton({
    super.key,
    required this.title,
    required this.color,
    required this.imgLink,
    required this.onTap,
  });

  final String title;
  final Color color;
  final String imgLink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: 0.20,
                  child: Container(
                    width: 95,
                    height: 75,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 37,
                  top: 26,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imgLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
