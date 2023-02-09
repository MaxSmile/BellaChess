import 'package:bellachess/model/app_model.dart';
//import 'package:bellachess/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/move_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UndoRedoButtons extends StatelessWidget {
  final AppModel appModel;

  bool get undoEnabled {
    if (appModel.playingWithAI) {
      return appModel.game!.board.moveStack.length > 1 && !appModel.isAIsTurn;
    } else {
      return appModel.game!.board.moveStack.isNotEmpty;
    }
  }

  bool get redoEnabled {
    if (appModel.playingWithAI) {
      return appModel.game!.board.redoStack.length > 1 && !appModel.isAIsTurn;
    } else {
      return appModel.game!.board.redoStack.isNotEmpty;
    }
  }

  const UndoRedoButtons(this.appModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                // child: Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.transparent,
                //       border: Border.all(color: Colors.white)),
                //   height: MediaQuery.of(context).size.height * 0.08,
                //   child: const Icon(
                //     CupertinoIcons.arrow_counterclockwise,
                //     color: Colors.white,
                //   ),
                // ),

                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    //border: Border.all(color: Colors.white)
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: const Icon(
                    CupertinoIcons.arrow_counterclockwise,
                    color: Colors.white,
                  ),
                ),
                onTap: undoEnabled ? () => undo() : null,
              ),
            ),
            const SizedBox(width: 10),

            // appModel.showMoveHistory
            //     ? Expanded(child: MoveList(appModel))
            //     : Container(),
            // const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.white),
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: const Icon(
                    CupertinoIcons.arrow_clockwise,
                    color: Colors.white,
                  ),
                ),
                onTap: redoEnabled ? () => redo() : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void undo() {
    if (appModel.playingWithAI) {
      appModel.game!.undoTwoMoves();
    } else {
      appModel.game!.undoMove();
    }
  }

  void redo() {
    if (appModel.playingWithAI) {
      appModel.game!.redoTwoMoves();
    } else {
      appModel.game!.redoMove();
    }
  }
}
