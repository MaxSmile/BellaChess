import 'package:bellachess/logic/chess_piece.dart';

class Move {
  int from;
  int to;
  ChessPieceType promotionType;

  Move(this.from, this.to, {this.promotionType = ChessPieceType.promotion});

  @override
  // ignore: avoid_renaming_method_parameters
  bool operator ==(move) => from == move.from && to == move.to;

  // ignore: unnecessary_overrides
  @override
  int get hashCode => super.hashCode;
}
