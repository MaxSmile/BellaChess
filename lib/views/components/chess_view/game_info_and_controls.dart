import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/chess_view/game_info_and_controls/allbutton.dart';
import 'package:bellachess/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/move_list.dart';
import 'package:flutter/cupertino.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  GameInfoAndControls(this.appModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height > 700 ? 410 : 134,
      ),
      child: ListView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          // Timers(appModel),
          MoveList(appModel),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: AllButtonsScreen(appModel),
          ),
          // MovesUndoRedoRow(appModel),
          // RestartExitButtons(appModel),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
