import 'dart:ui';

import 'package:bellachess/logic/shared_functions.dart';
import 'package:bellachess/model/app_model.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
//import 'package:flutter/cupertino.dart';

class PiecePreview extends FlameGame {
  AppModel appModel;

  Map<int, String> get imageMap {
    return {
      0: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/king_black.png',
      1: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/queen_white.png',
      2: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/rook_white.png',
      3: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/bishop_black.png',
      4: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/knight_black.png',
      5: 'pieces/${formatPieceTheme(appModel.pieceTheme)}/pawn_white.png',
    };
  }

  Map<int, Sprite> spriteMap = {};
  bool rendered = false;

  PiecePreview(this.appModel) {
    loadSpriteImages();
  }

  loadSpriteImages() async {
    for (var index = 0; index < 6; index++) {
      spriteMap[index] = Sprite(await Flame.images.load(imageMap[index]));
    }
  }

  @override
  // ignore: must_call_super
  void render(Canvas canvas) {
    for (var index = 0; index < 6; index++) {
      canvas.drawRect(
        Rect.fromLTWH((index % 2) * 40.0, (index / 2).floor() * 40.0, 40, 40),
        // TODO: DIFFERENT BOARDS STYLES
        Paint()
          ..color = (index + (index / 2).floor()) % 2 == 0
              ? appModel.theme.tilesColors.lightTile
              : appModel.theme.tilesColors.darkTile,
      );
      spriteMap[index].render(
        canvas,
        size: Vector2(30, 30),
        position: Vector2(
          (index % 2) * 40.0 + 5,
          (index / 2).floor() * 40.0 + 5,
        ),
      );
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters, must_call_super
  void update(double t) {}
}
