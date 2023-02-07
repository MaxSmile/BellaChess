import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../chess_view.dart';
import '../../settings_view.dart';

// ignore: must_be_immutable
class MainMenuButtons extends StatelessWidget {
  final AppModel appModel;

  MainMenuButtons(this.appModel, {Key key}) : super(key: key);
  InterstitialAd interstitialAd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: const BoxDecoration(
                color: Colorsdata.playbuttoncolors,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: const Center(
                child: Text(
              "Play",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            )),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) {
                  appModel.newGame(context, notify: false);
                  return ChessView(appModel);
                },
              ),
            );
            // interstitialAd.show();
          },
        ),
        // const SizedBox(height: 12),
        GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: appModel.themeName == "Dark"
                        ? Colors.white
                        : Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Center(
                child: Text(
              "Settings",
              style: TextStyle(
                  color: appModel.themeName == "Dark"
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            )),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const SettingsView(),
              ),
            );
            // interstitialAd.show();
          },
        ),
      ],
    );
  }
}
