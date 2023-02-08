// import 'dart:io';

import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/image.dart';
import 'package:bellachess/views/components/settings_view/board_colortheme.dart';
import 'package:bellachess/views/components/settings_view/piece_theme_picker.dart';
// import 'package:bellachess/views/components/webviewscreen.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'components/settings_view/app_theme_picker.dart';
import 'components/settings_view/toggles.dart';
import 'components/shared/bottom_padding.dart';
import 'components/shared/text_variable.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  InterstitialAd interstitialAd;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(appModel.themeName == "Dark"
                      ? Imageurl.secondbackground
                      : Imageurl.whitetheme),
                  fit: BoxFit.fill)),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  // Back button
                  Backbutton(
                    color: appModel.themeName == "Dark"
                        ? Colors.white
                        : Colors.black,
                  ),
                  // Space
                  SizedBox(
                    width: 20,
                  ),
                  // Title
                  TextLarges('Settings',
                      color: appModel.themeName == "Dark"
                          ? Colors.white
                          : Colors.black),
                ],
              ),
              Text(appModel.themeName),
              // TextLarges('Settings',
              //     color: appModel.themeName == "Dark"
              //         ? Colors.white
              //         : Colors.black),
              // const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const AppThemePicker(),
                    const SizedBox(height: 10),
                    Toggles(appModel),
                    const SizedBox(height: 10),
                    const BoardColortheme(),
                    const SizedBox(height: 10),
                    const PieceThemePicker(),
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
