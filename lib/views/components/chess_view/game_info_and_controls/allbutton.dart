import 'package:bellachess/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllButtonsScreen extends StatelessWidget {
  final AppModel appModel;

  const AllButtonsScreen(this.appModel, {Key key}) : super(key: key);
  bool get undoEnabled {
    if (appModel.playingWithAI) {
      return appModel.game.board.moveStack.length > 1 && !appModel.isAIsTurn;
    } else {
      return appModel.game.board.moveStack.isNotEmpty;
    }
  }

  bool get redoEnabled {
    if (appModel.playingWithAI) {
      return appModel.game.board.redoStack.length > 1 && !appModel.isAIsTurn;
    } else {
      return appModel.game.board.redoStack.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          child: Icon(
            CupertinoIcons.back,
            color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
          ),
          onTap: () {
            appModel.exitChessView();
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Icon(
            CupertinoIcons.arrow_uturn_left,
            color: undoEnabled
                ? (appModel.themeName == "Dark" ? Colors.white : Colors.black)
                : Colors.grey,
          ),
          onTap: undoEnabled ? () => undo() : null,
        ),
        GestureDetector(
          child: Icon(
            CupertinoIcons.arrow_uturn_right,
            color: redoEnabled
                ? (appModel.themeName == "Dark" ? Colors.white : Colors.black)
                : Colors.grey,
          ),
          onTap: redoEnabled ? () => redo() : null,
        ),
        GestureDetector(
          child: Icon(
            CupertinoIcons.arrow_2_circlepath,
            color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
          ),
          onTap: () {
            appModel.newGame(context);
          },
        ),
      ],
    );
  }

  void undo() {
    appModel.tryToShowAds();
    if (appModel.playingWithAI) {
      appModel.game.undoTwoMoves();
    } else {
      appModel.game.undoMove();
    }
  }

  void redo() {
    appModel.tryToShowAds();
    if (appModel.playingWithAI) {
      appModel.game.redoTwoMoves();
    } else {
      appModel.game.redoMove();
    }
  }
}
