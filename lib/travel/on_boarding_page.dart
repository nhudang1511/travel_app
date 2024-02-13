import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/login/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../config/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);
  static const String routeName = '/onBoarding';
  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    SharedService.setIsFirstTime(false);
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      pageColor: Colors.white,
      pageMargin: EdgeInsets.only(top: 100),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      pages: [
        CustomPageViewModel(
            context,
            pageDecoration,
            'assets/images/intro1.png',
            Alignment.bottomRight,
            "Book a flight",
            "Found a flight that matches your destination and schedule? Book it instantly."),
        CustomPageViewModel(
            context,
            pageDecoration,
            'assets/images/intro2.png',
            Alignment.center,
            "Find a hotel room",
            "Select the day, book your room. We give you the best price."),
        CustomPageViewModel(
            context,
            pageDecoration,
          'assets/images/intro3.png',
          Alignment.centerLeft,
            "Enjoy your trip",
          "Easy discovering new places and share these between your friends and travel together.",),

      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const CustomBoardingButton(
        title: 'Next',
      ),
      done: const CustomBoardingButton(title: 'Get Started'),
      curve: Curves.fastLinearToSlowEaseIn,
      dotsDecorator: const DotsDecorator(
        size: Size(5, 5),
        activeColor: Color(0xFFFE9C5E),
        color: Color(0xFFD8D8D8),
        activeSize: Size(20.0, 5.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  PageViewModel CustomPageViewModel(
      BuildContext context,
      PageDecoration pageDecoration,
      String image,
      Alignment imgAlign,
      String title,
      String body) {
    return PageViewModel(
        image: Image.asset(
          image,
          width: MediaQuery.of(context).size.width,
          alignment: imgAlign,
          fit: BoxFit.contain,
        ),
        decoration: pageDecoration,
        titleWidget: Container(
          margin: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(body,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left),
            ],
          ),
        ),
        body: '');
  }
}

class CustomBoardingButton extends StatelessWidget {
  const CustomBoardingButton({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFF8F67E8), Color(0xFF6357CC)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ));
  }
}
