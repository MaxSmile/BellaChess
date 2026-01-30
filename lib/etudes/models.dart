// lib/etudes/models.dart
// Data models for the Etude Challenge System

import 'package:bellachess/logic/move_calculation/move_classes/move.dart';

/// Represents a single etude (chess puzzle/exercise)
class Etude {
  final String id;
  final String title;
  final String fen; // Starting position in FEN notation
  final List<String> solution; // Solution moves in SAN (Standard Algebraic Notation)
  final String category; // Category: tactics, endgame, opening, etc.
  final int difficulty; // Difficulty level from 1-10
  final String theme; // Theme: pins, forks, skewers, etc.
  final int averageSolveTime; // Average time to solve in seconds
  final double successRate; // Success rate percentage
  final int attempts; // Total attempts
  final int solved; // Total successful solves
  final String description; // Explanation of the concept
  final DateTime createdAt;
  final String author; // Creator of the etude

  Etude({
    required this.id,
    required this.title,
    required this.fen,
    required this.solution,
    required this.category,
    required this.difficulty,
    required this.theme,
    this.averageSolveTime = 0,
    this.successRate = 0.0,
    this.attempts = 0,
    this.solved = 0,
    required this.description,
    required this.createdAt,
    required this.author,
  });

  /// Check if a move is the correct next move in the solution
  bool isCorrectMove(String moveSan, int moveIndex) {
    if (moveIndex >= solution.length) {
      return false; // Beyond the solution
    }
    return solution[moveIndex] == moveSan;
  }

  /// Get the correct move at a given index
  String? getCorrectMove(int moveIndex) {
    if (moveIndex >= 0 && moveIndex < solution.length) {
      return solution[moveIndex];
    }
    return null;
  }

  /// Calculate progress based on moves attempted
  double getProgress(int movesAttempted) {
    if (solution.isEmpty) return 0.0;
    return (movesAttempted / solution.length).clamp(0.0, 1.0);
  }
}

/// Represents a player's progress on a specific etude
class EtudeProgress {
  final String playerId;
  final String etudeId;
  final bool mastered;
  final int attempts; // Number of times attempted
  final int successes; // Number of successful completions
  final DateTime? lastAttempt;
  final DateTime? firstSolved;
  final List<int> solveTimes; // Times taken to solve in seconds
  final double rating; // Player's rating for this specific etude

  EtudeProgress({
    required this.playerId,
    required this.etudeId,
    this.mastered = false,
    this.attempts = 0,
    this.successes = 0,
    this.lastAttempt,
    this.firstSolved,
    required this.solveTimes,
    this.rating = 1200.0,
  });

  /// Calculate average solve time
  double get averageSolveTime {
    if (solveTimes.isEmpty) return 0.0;
    return solveTimes.reduce((a, b) => a + b) / solveTimes.length;
  }

  /// Calculate success rate
  double get successRate {
    if (attempts == 0) return 0.0;
    return (successes / attempts) * 100;
  }

  /// Determine if this etude is considered mastered based on performance
  bool get isMastered {
    if (successes < 3) return false; // Need at least 3 successful solves
    if (successRate < 80) return false; // Need 80%+ success rate
    if (solveTimes.isNotEmpty && averageSolveTime > 60) return false; // Should solve within 60 seconds on average
    
    return true;
  }

  /// Update progress after a solving attempt
  EtudeProgress updateAfterAttempt({
    required bool successful,
    required int solveTimeInSeconds,
  }) {
    final newAttempts = attempts + 1;
    final newSuccesses = successful ? successes + 1 : successes;
    final newSolveTimes = List<int>.from(solveTimes)..add(solveTimeInSeconds);
    final newLastAttempt = DateTime.now();
    final newFirstSolved = firstSolved ?? (successful ? DateTime.now() : null);
    final newMastered = isMastered || (successful && newSuccesses >= 3 && (newSuccesses / newAttempts) >= 0.8);

    // Adjust rating based on performance
    var newRating = rating;
    if (successful) {
      // Increase rating if solved quickly
      if (solveTimeInSeconds < averageSolveTime) {
        newRating += 10.0;
      } else {
        newRating += 5.0;
      }
    } else {
      // Decrease rating if unsuccessful
      newRating -= 15.0;
    }
    
    // Clamp rating between reasonable bounds
    newRating = newRating.clamp(800.0, 2500.0);

    return EtudeProgress(
      playerId: playerId,
      etudeId: etudeId,
      mastered: newMastered,
      attempts: newAttempts,
      successes: newSuccesses,
      lastAttempt: newLastAttempt,
      firstSolved: newFirstSolved,
      solveTimes: newSolveTimes,
      rating: newRating,
    );
  }
}

/// Represents a category of etudes
class EtudeCategory {
  final String id;
  final String name;
  final String description;
  final List<String> etudeIds; // List of etude IDs in this category
  final int difficultyRangeMin;
  final int difficultyRangeMax;
  final String theme; // Primary tactical theme

  EtudeCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.etudeIds,
    required this.difficultyRangeMin,
    required this.difficultyRangeMax,
    required this.theme,
  });

  /// Get number of etudes in this category
  int get count => etudeIds.length;

  /// Check if an etude belongs to this category based on difficulty
  bool matchesDifficulty(int difficulty) {
    return difficulty >= difficultyRangeMin && difficulty <= difficultyRangeMax;
  }
}

/// Represents a hint for an etude
class EtudeHint {
  final int moveIndex; // Which move in the solution this hint refers to
  final String hint; // Textual hint
  final String? highlightSquare; // Square to highlight on the board
  final List<String>? candidateMoves; // Moves to consider

  EtudeHint({
    required this.moveIndex,
    required this.hint,
    this.highlightSquare,
    this.candidateMoves,
  });
}