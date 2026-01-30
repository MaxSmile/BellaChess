// lib/interfaces/chess_types.dart
// Common interfaces to break circular dependencies

import 'package:bellachess/logic/move_calculation/move_classes/move.dart';
import 'package:bellachess/logic/chess_board.dart';
import 'package:bellachess/etudes/models.dart';

/// Interface for chess move analysis
abstract class MoveAnalyzer {
  /// Analyze a move during gameplay
  void analyzeMove({
    required int moveNumber,
    required Move move,
    required ChessBoard board,
    required double evaluationBefore,
    required double evaluationAfter,
    required int maxDepth,
  });
}

/// Interface for etude validation
abstract class EtudeValidator {
  /// Validate a move in the context of an etude
  bool validateMove({
    required String etudeId,
    required Move move,
    required int currentMoveIndex,
    required ChessBoard board,
  });

  /// Get a hint for the current position in an etude
  EtudeHint? getHint(String etudeId, int currentMoveIndex);
}

/// Interface for etude management
abstract class EtudeManager {
  /// Get an etude by ID
  Etude? getEtudeById(String id);

  /// Get all etudes in a category
  List<Etude> getEtudesByCategory(String category);

  /// Get a recommended etude based on player progress
  Etude? getRecommendedEtude(String playerId);
}

/// Interface for NFT management related to chess
abstract class NFTManager {
  /// Award an NFT for etude mastery
  Future<bool> awardMasteryNFT({
    required String playerId,
    required Etude etude,
    required String playerName,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
  });

  /// Award an achievement NFT
  Future<bool> awardAchievementNFT({
    required String playerId,
    required String achievementType,
    required String achievementName,
    required String achievementDescription,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
    String? relatedEntityId,
  });
}