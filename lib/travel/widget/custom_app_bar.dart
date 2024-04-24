import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/image_helper.dart';
import '../../config/app_path.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key, required this.titlePage, required this.subTitlePage, this.isFirst = false,
  });
  final String titlePage;
  final String subTitlePage;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !isFirst ? GestureDetector(
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
            ): const SizedBox(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                        titlePage,
                        style: Theme.of(context).textTheme.displayLarge
                    ),
                    if(subTitlePage.isNotEmpty)
                      const SizedBox(height: 15),
                      Text(
                        subTitlePage,
                        style: Theme.of(context).textTheme.bodyLarge)

                  ],
                ),
              ),
            ),
          ],
        ),
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
            child: ImageHelper.loadFromAsset(
                AppPath.iconTop),
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
      backgroundColor: Colors.transparent,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(180.0);
}