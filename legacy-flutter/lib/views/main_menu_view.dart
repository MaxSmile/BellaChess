import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/image.dart';
import 'package:bellachess/views/components/main_menu_view/game_options.dart';
import 'package:bellachess/views/components/shared/bottom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'components/main_menu_view/main_menu_buttons.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({Key? key}) : super(key: key);

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  InterstitialAd? interstitialAd;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(appModel.themeName == "Dark"
                        ? Imageurl.secondbackground
                        : Imageurl.whitebackgroundtheme),
                    fit: BoxFit.fill)),
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  // padding: EdgeInsets.fromLTRB(
                  //     5, MediaQuery.of(context).padding.top + 10, 5, 0),
                  child: Image.asset(Imageurl.chessgroupbackground),
                ),
                const SizedBox(height: 20),
                GameOptions(appModel),
                const SizedBox(height: 20),
                MainMenuButtons(appModel),
                const SizedBox(height: 20),
                const BottomPadding(),
              ],
            ),
          ),
        );
      },
    );
  }
}
