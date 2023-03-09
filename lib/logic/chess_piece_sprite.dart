import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'chess_piece.dart';
import 'shared_functions.dart';

class ChessPieceSprite {
  ChessPieceType? type;
  String pieceTheme;
  int? tile;
  late Sprite sprite;
  late double spriteX;
  late double spriteY;
  double offsetX = 0;
  double offsetY = 0;

  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  ChessPieceSprite(ChessPiece piece, this.pieceTheme, bool flip) {
    tile = piece.tile;
    type = piece.type;
    initSprite(piece, flip);
  }

  void update(double? tileSize, AppModel appModel, ChessPiece piece) {
    if (piece.type != type) {
      type = piece.type;
      initSprite(piece, appModel.flip);
    }
    if (piece.tile != tile) {
      tile = piece.tile;
      offsetX = 0;
      offsetY = 0;
    }
    var destX = getXFromTile(tile, tileSize, appModel);
    var destY = getYFromTile(tile, tileSize, appModel);
    if ((destX - spriteX).abs() <= 0.1) {
      spriteX = destX;
      offsetX = 0;
    } else {
      if (offsetX == 0) {
        offsetX = (destX - spriteX) / 10;
      }
      spriteX += offsetX;
      playSound(destX, destY, appModel);
    }
    if ((destY - spriteY).abs() <= 0.1) {
      spriteY = destY;
      offsetY = 0;
    } else {
      if (offsetY == 0) {
        offsetY += (destY - spriteY) / 10;
      }
      spriteY += offsetY;
      playSound(destX, destY, appModel);
    }
  }

  void playSound(double destX, double destY, AppModel appModel) async {
    if ((destX - spriteX).abs() <= 0.1 && (destY - spriteY).abs() <= 0.1) {
      audioPlayer.play(AssetSource('audio/piece_moved.mp3'));
      //audioPlayer.setSource(AssetSource('audio/piece_moved.mp3'));
    }
  }

  void initSprite(ChessPiece piece, bool flip) async {
    log("object filp $flip");
    log("object piece.player ${piece.player}");
    String color = !flip
        ? piece.player == Player.player1
            ? 'black'
            : 'white'
        : piece.player == Player.player1
            ? 'black'
            : 'white';
    // : piece.player != Player.player2
    //     ? 'white'
    //     : 'black';
    // String color = flip
    //     ? piece.player != Player.player1
    //         ? 'black'
    //         : 'white'
    //     : piece.player != Player.player1
    //         ? 'white'
    //         : 'black';
    String pieceName = pieceTypeToString(piece.type);
    if (piece.type == ChessPieceType.promotion) {
      pieceName = 'pawn';
    }
    sprite = Sprite(await Flame.images.load(
        'pieces/${formatPieceTheme(pieceTheme)}/${pieceName}_$color.png'));
  }

  void initSpritePosition(double? tileSize, AppModel appModel) {
    spriteX = getXFromTile(tile, tileSize, appModel);
    spriteY = getYFromTile(tile, tileSize, appModel);
  }
}
