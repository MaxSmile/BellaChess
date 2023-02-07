import 'package:bellachess/logic/chess_piece.dart';
import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/chess_view/promotion_option.dart';
import 'package:flutter/cupertino.dart';

// ignore: constant_identifier_names
const PROMOTIONS = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight
];

class PromotionDialog extends StatelessWidget {
  final AppModel appModel;

  const PromotionDialog(this.appModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        SizedBox(
          height: 66,
          child: Row(
            children: PROMOTIONS
                .map(
                  (promotionType) => PromotionOption(
                    appModel,
                    promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
