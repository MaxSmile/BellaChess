import 'dart:developer';

import 'package:async/async.dart';
import 'package:bellachess/logic/chess_piece_sprite.dart';
import 'package:bellachess/logic/move_calculation/ai_move_calculation.dart';
import 'package:bellachess/logic/move_calculation/move_calculation.dart';
import 'package:bellachess/logic/move_calculation/move_classes/move_meta.dart';
import 'package:bellachess/logic/shared_functions.dart';
import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/model/app_stringfile.dart';
import 'package:bellachess/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes/move.dart';

class ChessGame extends FlameGame with TapDetector {
  late double width;
  double? tileSize;
  AppModel appModel;
  BuildContext context;
  ChessBoard board = ChessBoard();
  Map<ChessPiece, ChessPieceSprite> spriteMap = {};

  CancelableOperation? aiOperation;
  List<int> validMoves = [];
  ChessPiece? selectedPiece;
  int? checkHintTile;
  Move? latestMove;

  ChessGame(this.appModel, this.context) {
    // print("object data");
    // log(appModel.toString());
    // log(context.toString());
    width = MediaQuery.of(context).size.width;
    tileSize = width / 9;
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] =
          ChessPieceSprite(piece, appModel.pieceTheme, appModel.flip);
    }
    _initSpritePositions();
    if (appModel.isAIsTurn) {
      _aiMove();
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void onTapDown(TapDownInfo details) {
    if (appModel.gameOver || !(appModel.isAIsTurn)) {
      var tile = _vector2ToTile(details.eventPosition.widget);
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == selectedPiece) {
        validMoves = [];
        selectedPiece = null;
      } else {
        if (selectedPiece != null &&
            touchedPiece != null &&
            touchedPiece.player == selectedPiece!.player) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (selectedPiece == null) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  Sprite? player;

  @override
  Future<void> onLoad() async {
    final playerImage = await images
        .load('board.png'); // Note that you could also use Sprite.load for this
    player = Sprite(
      playerImage,
      srcPosition: Vector2(102.0, 100),
      srcSize: Vector2(16.0, 16.0),
    );
  }

  @override
  // ignore: must_call_super
  void render(Canvas canvas) {
    onLoad();
    if (appModel != null) {
      // _boardboder(canvas);

      _drawBoard(canvas);
      if (appModel.showHints) {
        _drawCheckHint(canvas);
        _drawLatestMove(canvas);
      }
      _drawSelectedPieceHint(canvas);
      _drawPieces(canvas);
      if (appModel.showHints) {
        _drawMoveHints(canvas);
      }
    }
  }

  @override
  // ignore: must_call_super, avoid_renaming_method_parameters
  void update(double t) {
    if (appModel != null) {
      for (var piece in board.player1Pieces + board.player2Pieces) {
        spriteMap[piece]!.update(tileSize, appModel, piece);
      }
    }
  }

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]!.initSpritePosition(tileSize, appModel);
    }
  }

  void _selectPiece(ChessPiece? piece) {
    if (piece != null) {
      if (piece.player == appModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          validMoves = movesForPiece(piece, board);
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      var meta = push(Move(selectedPiece!.tile, tile), board, getMeta: true);
      if (meta.promotion) {
        appModel.requestPromotion();
      }
      _moveCompletion(meta, changeTurn: !meta.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(const Duration(milliseconds: 500));
    var args = {};
    args['aiPlayer'] = appModel.aiTurn;
    args['aiDifficulty'] = appModel.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation!.value.then((move) {
      if (move == null || appModel.gameOver) {
        appModel.endGame();
      } else {
        validMoves = [];
        var meta = push(move, board, getMeta: true);
        _moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          promote(move.promotionType);
        }
      }
    });
  }

  void cancelAIMove() {
    if (aiOperation != null) {
      aiOperation!.cancel();
    }
  }

  void undoMove() {
    board.redoStack.add(pop(board));
    if (appModel.moveMetaList.length > 1) {
      var meta = appModel.moveMetaList[appModel.moveMetaList.length - 2];
      _moveCompletion(meta, clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      appModel.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    appModel.popMoveMeta();
    if (appModel.moveMetaList.length > 1) {
      _moveCompletion(appModel.moveMetaList[appModel.moveMetaList.length - 2],
          clearRedo: false, undoing: true, changeTurn: false);
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    appModel.popMoveMeta();
  }

  void redoMove() {
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false);
  }

  void redoTwoMoves() {
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
  }

  void promote(ChessPieceType? type) {
    board.moveStack.last.movedPiece!.type = type;
    board.moveStack.last.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    appModel.moveMetaList.last.promotionType = type;
    _moveCompletion(appModel.moveMetaList.last, updateMetaList: false);
  }

  void _moveCompletion(
    MoveMeta meta, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    latestMove = meta.move;
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(appModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      checkHintTile = kingForPlayer(oppositeTurn, board)!.tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!meta.isCheck) {
        appModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      appModel.endGame();
    }
    if (undoing) {
      appModel.popMoveMeta();
      appModel.undoEndGame();
    } else if (updateMetaList) {
      appModel.pushMoveMeta(meta);
    }
    if (changeTurn) {
      appModel.changeTurn();
    }
    selectedPiece = null;
    if (appModel.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  int _vector2ToTile(Vector2 vector2) {
    if (appModel.flip &&
        appModel.playingWithAI &&
        appModel.playerSide == Player.player2) {
      return (7 - (vector2.y / tileSize!).floor()) * 8 +
          (7 - (vector2.x / tileSize!).floor());
    } else {
      return (vector2.y / tileSize!).floor() * 8 +
          (vector2.x / tileSize!).floor();
    }
  }

  // void _drawBoard(Canvas canvas) {
  //   for (int tileNo = 0; tileNo < 64; tileNo++) {
  //     canvas.drawRect(
  //       Rect.fromLTWH(
  //         (tileNo % 8) * tileSize,
  //         (tileNo / 8).floor() * tileSize,
  //         tileSize,
  //         tileSize,
  //       ),
  //       // TODO: DIFFERENT BORDS STYLES
  //       Paint()
  //         ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
  //             ? appModel.theme.tilesColors.lightTile
  //             : appModel.theme.tilesColors.darkTile,
  //     );
  //   }
  // }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * tileSize!,
          (tileNo / 8).floor() * tileSize!,
          tileSize!,
          tileSize!,
        ),
        // TODO: DIFFERENT BORDS STYLES
        Paint()
          ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
              ? appModel.boardColor == BoardColor.blacknwhite
                  ? appModel.theme.tilesColors.blacknwhitelight
                  : appModel.boardColor == BoardColor.midnight
                      ? appModel.theme.tilesColors.midnightlight
                      : appModel.boardColor == BoardColor.green
                          ? appModel.theme.tilesColors.greenlight
                          : appModel.boardColor == BoardColor.blue
                              ? appModel.theme.tilesColors.bluelight
                              : appModel.theme.tilesColors.lightTile
              : appModel.boardColor == BoardColor.blacknwhite
                  ? appModel.theme.tilesColors.blacknwhitedark
                  : appModel.boardColor == BoardColor.midnight
                      ? appModel.theme.tilesColors.midnightdark
                      : appModel.boardColor == BoardColor.green
                          ? appModel.theme.tilesColors.greendark
                          : appModel.boardColor == BoardColor.blue
                              ? appModel.theme.tilesColors.bluedark
                              : appModel.theme.tilesColors.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]!.sprite.render(
            canvas,
            size: Vector2(tileSize! - 2, tileSize! - 2),
            position: Vector2(
              spriteMap[piece]!.spriteX + 1,
              spriteMap[piece]!.spriteY + 1,
            ),
          );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, tileSize, appModel) + (tileSize! / 2),
          getYFromTile(tile, tileSize, appModel) + (tileSize! / 2),
        ),
        tileSize! / 5,
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    if (latestMove != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.from, tileSize, appModel),
          getYFromTile(latestMove!.from, tileSize, appModel),
          tileSize!,
          tileSize!,
        ),
        Paint()..color = appModel.theme.latestMove,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.to, tileSize, appModel),
          getYFromTile(latestMove!.to, tileSize, appModel),
          tileSize!,
          tileSize!,
        ),
        Paint()..color = appModel.theme.latestMove,
      );
    }
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(checkHintTile, tileSize, appModel),
          getYFromTile(checkHintTile, tileSize, appModel),
          tileSize!,
          tileSize!,
        ),
        Paint()..color = appModel.theme.checkHint,
      );
    }
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(selectedPiece!.tile, tileSize, appModel),
          getYFromTile(selectedPiece!.tile, tileSize, appModel),
          tileSize!,
          tileSize!,
        ),
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }
}
