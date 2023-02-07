import 'package:bellachess/logic/chess_piece.dart';
import 'package:bellachess/logic/move_calculation/move_classes/move_meta.dart';
import 'package:bellachess/logic/shared_functions.dart';
import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:bellachess/views/components/shared/text_variable.dart';
import 'package:flutter/material.dart';

class MoveList extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  MoveList(this.appModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color:
            appModel.themeName == "Dark" ? Colors.grey[800] : Color(0xfff2f2f2),
        //border: Border.all(color: Colors.white)
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Center(
            child: TextRegularboard(_allMoves(),
                color: appModel.themeName == "Dark"
                    ? Colors.white.withOpacity(0.7)
                    : Color(0xff000000).withOpacity(0.7))),
      ),
    );
  }

  void _scrollToBottom() {
    if (appModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      appModel.moveListUpdated = false;
    }
  }

  String _allMoves() {
    var moveString = '';
    appModel.moveMetaList.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += _moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    if (appModel.gameOver) {
      if (appModel.turn == Player.player1) {
        moveString += ' ';
      }
      if (appModel.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString += appModel.turn == Player.player2 ? '  1-0' : '  0-1';
      }
    }
    return moveString;
  }

  String _moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = 'O-O';
    } else if (meta.queenCastle) {
      move = 'O-O-O';
    } else {
      String ambiguity =
          meta.rowIsAmbiguous ? _colToChar(tileToCol(meta.move.from)) : '';
      ambiguity +=
          meta.colIsAmbiguous ? '${8 - tileToRow(meta.move.from)}' : '';
      String takeString = meta.took ? 'x' : '';
      String promotion =
          meta.promotion ? '=${_pieceToChar(meta.promotionType)}' : '';
      String row = '${8 - tileToRow(meta.move.to)}';
      String col = _colToChar(tileToCol(meta.move.to));
      move = '${_pieceToChar(meta.type)}$ambiguity$takeString'
          '$col$row$promotion';
    }
    String check = meta.isCheck ? '+' : '';
    String checkmate = meta.isCheckmate && !meta.isStalemate ? '#' : '';
    return move + '$check$checkmate';
  }

  String _pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king:
        {
          return 'K';
        }
      case ChessPieceType.queen:
        {
          return 'Q';
        }
      case ChessPieceType.rook:
        {
          return 'R';
        }
      case ChessPieceType.bishop:
        {
          return 'B';
        }
      case ChessPieceType.knight:
        {
          return 'N';
        }
      case ChessPieceType.pawn:
        {
          return '';
        }
      default:
        {
          return '?';
        }
    }
  }

  String _colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
