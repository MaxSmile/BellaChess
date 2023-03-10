import 'dart:async';
import 'dart:io';

import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/chess_view/chess_board_widget.dart';
import 'package:bellachess/views/components/chess_view/game_info_and_controls.dart';
import 'package:bellachess/views/components/chess_view/game_info_and_controls/game_status_computer.dart';
import 'package:bellachess/views/components/chess_view/promotion_dialog.dart';
import 'package:bellachess/views/components/image.dart';
import 'package:bellachess/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:bellachess/views/lossscreen.dart';
import 'package:bellachess/views/winscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'components/chess_view/game_info_and_controls/game_status.dart';
import 'components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  const ChessView(this.appModel, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  AppModel appModel;

  _ChessViewState(this.appModel);
  // ignore: unused_field
  BannerAd? _bannerAd;

  @override
  void initState() {
    BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-1743741155411869/9954608614'
          : 'ca-app-pub-1743741155411869/4154026527',
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return SafeArea(
          child: WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                      image: AssetImage(appModel.themeName == "Dark"
                          ? Imageurl.secondbackground
                          : Imageurl.secondwhitebackground),
                      fit: BoxFit.fill)),
              // decoration: BoxDecoration(gradient: appModel.theme.background),
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  // myBanner.load();
                  if (_bannerAd != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  const Spacer(),
                  if (!appModel.flip)
                    appModel.playerSide != Player.player1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatus(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatusComputerScreen(),
                          ),
                  if (appModel.flip)
                    appModel.playerSide != Player.player1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatus(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatusComputerScreen(),
                          ),
                  const SizedBox(height: 20),

                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ChessBoardWidget(appModel),
                      ),
                      if (appModel.gameOver)
                        if (appModel.playerCount == 1)
                          if (appModel.isAIsTurn)
                            Center(
                              child: WinScreen(
                                callback: (value) {
                                  if (value == "play") {
                                    appModel.newGame(context);
                                  } else {
                                    appModel.exitChessView();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                      if (appModel.gameOver)
                        if (appModel.playerCount != 1)
                          if (appModel.turn == Player.player1)
                            Center(
                              child: LossScreen(
                                colorname: 'Black wins',
                                callback: (value) {
                                  if (value == "play") {
                                    appModel.newGame(context);
                                  } else {
                                    appModel.exitChessView();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                      if (appModel.gameOver)
                        if (appModel.playerCount != 1)
                          if (appModel.turn != Player.player1)
                            Center(
                              child: LossScreen(
                                colorname: 'White wins',
                                callback: (value) {
                                  if (value == "play") {
                                    appModel.newGame(context);
                                  } else {
                                    appModel.exitChessView();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  if (appModel.flip)
                    appModel.playerSide == Player.player1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatus(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatusComputerScreen(),
                          ),
                  if (!appModel.flip)
                    appModel.playerSide == Player.player1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatus(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const GameStatusComputerScreen(),
                          ),

                  const Spacer(),
                  GameInfoAndControls(appModel),

                  const BottomPadding(),
                  // bottom screen
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }

  Future<bool> _willPopCallback() async {
    if (appModel != null) {
      appModel.exitChessView();
    }
    return true;
  }
}
