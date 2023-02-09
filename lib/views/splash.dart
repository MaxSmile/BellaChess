import 'dart:async';

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bellachess/views/components/image.dart';
import 'package:bellachess/views/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final colorizeColors = [
    Colors.white,
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  final colorizeTextStyle = const TextStyle(
    fontSize: 40.0,
  );
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () => Get.off(const MainMenuView()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Imageurl.splashbackground), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    child: Image.asset(Imageurl.splashuppart)),
                // AnimatedTextKit(
                //   animatedTexts: [
                //     ColorizeAnimatedText(
                //       'Bella Chess ',
                //       textStyle: colorizeTextStyle,
                //       colors: colorizeColors,
                //     ),
                //   ],
                //   isRepeatingAnimation: true,
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                const Text(
                  "Bella Chess ",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
