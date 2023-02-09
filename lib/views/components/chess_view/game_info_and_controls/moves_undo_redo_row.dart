import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/undo_redo_buttons.dart';
import 'package:flutter/cupertino.dart';

// import 'moves_undo_redo_row/move_list.dart';

class MovesUndoRedoRow extends StatelessWidget {
  final AppModel appModel;

  const MovesUndoRedoRow(this.appModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // appModel.showMoveHistory && appModel.allowUndoRedo
            // ? const SizedBox(width: 10)
            // : Container(),
            appModel.allowUndoRedo
                ? Expanded(child: UndoRedoButtons(appModel))
                : Container(),
          ],
        ),
        appModel.showMoveHistory || appModel.allowUndoRedo
            ? const SizedBox(height: 10)
            : Container(),
      ],
    );
  }
}
