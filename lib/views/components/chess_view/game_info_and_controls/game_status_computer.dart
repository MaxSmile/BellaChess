import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/chess_view/game_info_and_controls/timer_widget.dart';
import 'package:bellachess/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:bellachess/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GameStatusComputerScreen extends StatelessWidget {
  const GameStatusComputerScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Row(
        children: [
          TextRegular(_getStatus(appModel),
              color:
                  appModel.themeName == "Dark" ? Colors.white : Colors.black),
          !appModel.gameOver && appModel.playerCount == 1 && appModel.isAIsTurn
              ? const CupertinoActivityIndicator(radius: 12)
              : Container(),
          TimerWidget(
            timeLeft: appModel.player2TimeLeft,
            themename: appModel.themeName,
            color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  String _getStatus(AppModel appModel) {
    if (!appModel.gameOver) {
      if (appModel.playerCount == 1) {
        return 'Computer';
      } else {
        if (appModel.turn == Player.player1) {
          return 'White\'s turn';
        } else {
          return 'Black\'s turn';
        }
      }
    } else {
      if (appModel.stalemate) {
        return 'Stalemate';
      } else {
        if (appModel.playerCount == 1) {
          if (appModel.isAIsTurn) {
            return 'You Win!';
          } else {
            return 'You Lose ';
          }
        } else {
          if (appModel.turn == Player.player1) {
            return 'Black wins!';
          } else {
            return 'White wins!';
          }
        }
      }
    }
  }
}
