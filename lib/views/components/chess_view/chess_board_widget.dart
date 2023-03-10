import 'package:bellachess/logic/chess_game.dart';
import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/model/app_stringfile.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class ChessBoardWidget extends StatelessWidget {
  final AppModel appModel;

  const ChessBoardWidget(this.appModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //debugPrint("MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width / 9}");
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width + 10,
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage(appModel.boardColor == BoardColor.blacknwhite
                          ? "assets/images/blacnwhite.png"
                          : appModel.boardColor == BoardColor.midnight
                              ? "assets/images/midboard.png"
                              : appModel.boardColor == BoardColor.green
                                  ? "assets/images/greenboard.png"
                                  : appModel.boardColor == BoardColor.blue
                                      ? "assets/images/blueboard.png"
                                      : "assets/images/board.png"),
                  fit: BoxFit.fill)),
        ),
        Center(
          child: SizedBox(
            child: GameWidget(game: appModel.game as ChessGame),
            width: MediaQuery.of(context).size.width -
                MediaQuery.of(context).size.width / 9,
            height: MediaQuery.of(context).size.width -
                MediaQuery.of(context).size.width / 9,
          ),
        ),
      ],
    );
  }
}
