import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../config/app_path.dart';
import '../../../../config/image_helper.dart';

class CustomAppBarItem extends StatefulWidget {
  const CustomAppBarItem(
      {super.key,
      required this.child,
      required this.title,
      required this.isIcon,
      this.filterButton,
      required this.showModalBottomSheet,
      this.isFirst = false});

  final Widget child;
  final String title;
  final bool isIcon;
  final Widget? filterButton;
  final VoidCallback showModalBottomSheet;
  final bool isFirst;

  @override
  State<CustomAppBarItem> createState() => _CustomAppBarItemState();
}

class _CustomAppBarItemState extends State<CustomAppBarItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SizedBox(
            height: 186,
            child: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !widget.isFirst ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ) : const SizedBox() ,
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.title,
                              style: Theme.of(context).textTheme.displayLarge),
                        ],
                      ),
                    ),
                  ),
                  widget.isIcon
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              widget.showModalBottomSheet();
                            },
                            child: const Icon(FontAwesomeIcons.bars,
                                size: 16.0, color: Colors.black),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              flexibleSpace: Stack(
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
                    child: ImageHelper.loadFromAsset(AppPath.iconTop),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ImageHelper.loadFromAsset(
                      AppPath.iconBottom,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: const Color(0xFFF2F2F2),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 130, left: 10, right: 5),
            child: SingleChildScrollView(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}

class ButtonFilter extends StatelessWidget {
  const ButtonFilter({
    super.key,
    required this.title,
    required this.color,
    required this.image,
    required this.onTap,
  });

  final String title;
  final int color;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: ShapeDecoration(
                color: Color(color).withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Image.asset(image),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
