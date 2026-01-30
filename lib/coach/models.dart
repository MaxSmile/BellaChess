// lib/coach/models.dart
// Data models for the AI Coach System

import 'package:bellachess/logic/move_calculation/move_classes/move.dart';

/// Enum representing the quality of a move
enum MoveQuality {
  excellent,
  good,
  inaccuracy,
  mistake,
  blunder,
}

/// Enum representing complexity of a position
enum ComplexityRating {
  quiet,
  moderate,
  complex,
  critical,
}

/// Represents analysis of a single move
class MoveAnalysis {
  final int moveNumber;
  final Move move;
  final double evaluation; // Evaluation from player's perspective
  final MoveQuality quality;
  final List<String> alternatives; // SAN notation of alternative moves
  final String explanation;
  final DateTime timestamp;

  MoveAnalysis({
    required this.moveNumber,
    required this.move,
    required this.evaluation,
    required this.quality,
    required this.alternatives,
    required this.explanation,
  }) : timestamp = DateTime.now();
}

/// Represents evaluation of a specific position
class PositionEvaluation {
  final String fen;
  final double evaluation;
  final ComplexityRating complexity;
  final bool hasTacticalOpportunities;
  final List<String> tacticalMoves; // Moves that exploit tactics
  final String positionType; // Opening, middlegame, endgame

  PositionEvaluation({
    required this.fen,
    required this.evaluation,
    required this.complexity,
    required this.hasTacticalOpportunities,
    required this.tacticalMoves,
    required this.positionType,
  });
}

/// Summary of mistakes in a game
class MistakeSummary {
  final int blunders;
  final int mistakes;
  final int inaccuracies;
  final double averageCentipawnLoss;

  MistakeSummary({
    required this.blunders,
    required this.mistakes,
    required this.inaccuracies,
    required this.averageCentipawnLoss,
  });

  /// Calculate overall mistake score (lower is better)
  double get mistakeScore {
    return (blunders * 3.0) + (mistakes * 2.0) + inaccuracies;
  }
}

/// Improvement suggestions based on game analysis
class ImprovementSuggestions {
  final List<String> tacticalAreas; // Areas needing tactical improvement
  final List<String> strategicAreas; // Areas needing strategic improvement
  final List<String> recommendedEtudes; // Specific etudes to practice
  final String generalAdvice;

  ImprovementSuggestions({
    required this.tacticalAreas,
    required this.strategicAreas,
    required this.recommendedEtudes,
    required this.generalAdvice,
  });
}

/// Complete analysis of a single game
class GameAnalysis {
  final String gameId;
  final DateTime timestamp;
  final String result; // "win", "loss", "draw"
  final List<MoveAnalysis> moves;
  final PositionEvaluation? criticalPosition;
  final MistakeSummary mistakeSummary;
  final ImprovementSuggestions suggestions;
  final double performanceRatingChange; // Change in player's rating

  GameAnalysis({
    required this.gameId,
    required this.timestamp,
    required this.result,
    required this.moves,
    this.criticalPosition,
    required this.mistakeSummary,
    required this.suggestions,
    required this.performanceRatingChange,
  });
}

/// Player profile containing skill assessment
class PlayerProfile {
  double rating; // Current skill rating
  Map<String, double> skillAreas; // Skill in different areas (0.0-10.0 scale)
  List<GameAnalysis> gameHistory;
  DateTime createdAt;
  DateTime lastActive;
  int gamesPlayed;
  int gamesWon;
  int gamesDrawn;
  int gamesLost;

  PlayerProfile({
    this.rating = 1200.0, // Starting rating similar to beginner
    required this.skillAreas,
    required this.gameHistory,
    required this.createdAt,
    required this.lastActive,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.gamesDrawn = 0,
    this.gamesLost = 0,
  });

  /// Calculate win rate
  double get winRate => gamesPlayed > 0 ? gamesWon / gamesPlayed : 0.0;

  /// Get skill area with lowest score (biggest weakness)
  String get biggestWeakness {
    if (skillAreas.isEmpty) return 'general';
    
    String weakestArea = skillAreas.keys.first;
    double lowestScore = skillAreas[weakestArea]!;
    
    for (final entry in skillAreas.entries) {
      if (entry.value < lowestScore) {
        lowestScore = entry.value;
        weakestArea = entry.key;
      }
    }
    
    return weakestArea;
  }

  /// Update profile with results from a new game
  void updateWithGame(GameAnalysis analysis) {
    gameHistory.add(analysis);
    lastActive = DateTime.now();
    gamesPlayed++;
    
    switch (analysis.result) {
      case 'win':
        gamesWon++;
        break;
      case 'draw':
        gamesDrawn++;
        break;
      case 'loss':
        gamesLost++;
        break;
    }
    
    // Update rating based on performance
    rating += analysis.performanceRatingChange;
    
    // Update skill areas based on improvement suggestions
    for (final area in analysis.suggestions.tacticalAreas) {
      skillAreas[area] = (skillAreas[area] ?? 5.0) - 0.2; // Lower score indicates weakness
    }
    
    for (final area in analysis.suggestions.strategicAreas) {
      skillAreas[area] = (skillAreas[area] ?? 5.0) - 0.2;
    }
    
    // Ensure skill scores stay within bounds
    for (final key in skillAreas.keys) {
      skillAreas[key] = skillAreas[key]!.clamp(0.0, 10.0);
    }
  }
}