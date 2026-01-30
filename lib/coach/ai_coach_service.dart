// lib/coach/ai_coach_service.dart
// Service layer to integrate AI Coach with the app model

import 'package:bellachess/coach/ai_coach.dart';
import 'package:bellachess/coach/models.dart';
import 'package:bellachess/logic/chess_board.dart';
import 'package:bellachess/logic/move_calculation/move_classes/move.dart';

class AI_CoachService {
  final AICoach _aiCoach = AICoach();
  final Set<String> _completedTrainings = {};
  final List<String> _improvementAreas = [];
  final List<String> _strengths = [];

  /// Get the current player profile
  PlayerProfile? getPlayerProfile() {
    return _aiCoach.getPlayerProfile();
  }

  /// Analyze a single move during gameplay
  MoveAnalysis analyzeMove({
    required int moveNumber,
    required Move move,
    required ChessBoard board,
    required double evaluationBefore,
    required double evaluationAfter,
    required int maxDepth,
  }) {
    return _aiCoach.analyzeMove(
      moveNumber: moveNumber,
      move: move,
      board: board,
      evaluationBefore: evaluationBefore,
      evaluationAfter: evaluationAfter,
      maxDepth: maxDepth,
    );
  }

  /// Analyze an entire game after completion
  Future<GameAnalysis> analyzeGame({
    required String gameId,
    required String result, // "win", "loss", "draw"
    required List<MoveAnalysis> moves,
    required double opponentRating,
  }) async {
    return await _aiCoach.analyzeGame(
      gameId: gameId,
      result: result,
      moves: moves,
      opponentRating: opponentRating,
    );
  }

  /// Evaluate a position for complexity and tactical opportunities
  PositionEvaluation evaluatePosition(ChessBoard board, String fen) {
    return _aiCoach.evaluatePosition(board, fen);
  }

  /// Generate improvement suggestions based on a game analysis
  ImprovementSuggestions generateImprovementSuggestions(GameAnalysis analysis) {
    return _aiCoach.generateImprovementSuggestions(analysis);
  }

  /// Get personalized etude recommendations based on player weaknesses
  List<String> getEtudeRecommendations({int count = 5}) {
    final profile = _aiCoach.getPlayerProfile();
    if (profile == null) return [];

    // Return etudes focused on the player's biggest weakness
    final weakness = profile.biggestWeakness;
    final recommendations = <String>[];

    // This would connect to the etude system once implemented
    switch (weakness) {
      case 'tactics':
        recommendations.addAll([
          'Basic Tactics 101',
          'Pin and Fork Exercises',
          'Double Attack Patterns',
          'Skewer Combinations',
          'Deflection Tactics'
        ]);
        break;
      case 'endgame':
        recommendations.addAll([
          'King and Pawn Endgames',
          'Basic Checkmates',
          'Rook Endgame Principles',
          'Minor Piece Endgames',
          'Pawn Structure Endgames'
        ]);
        break;
      case 'openings':
        recommendations.addAll([
          'Opening Principles',
          'Common Opening Traps',
          'Classical Openings',
          'Semi-Open Games',
          'Flank Openings'
        ]);
        break;
      default:
        recommendations.addAll([
          'Mixed Tactical Puzzles',
          'Strategic Positional Play',
          'Endgame Technique',
          'Calculation Practice',
          'Pattern Recognition'
        ]);
    }

    return recommendations.take(count).toList();
  }

  /// Record training activity and update player profile
  Future<void> recordTrainingActivity(String trainingType, bool successful) async {
    // Update the player's profile based on training activity
    // This would typically update internal tracking of the player's progress
    if (successful) {
      // Add the training type to completed activities
      _completedTrainings.add(trainingType);
      
      // Potentially adjust improvement areas based on successful training
      if (_improvementAreas.contains(trainingType)) {
        _improvementAreas.remove(trainingType);
        _strengths.add(trainingType);
      }
    } else {
      // If training wasn't successful, potentially reinforce it as an improvement area
      if (!_improvementAreas.contains(trainingType)) {
        _improvementAreas.add(trainingType);
      }
    }
  }

  /// Get identified weaknesses for the player
  List<String> getIdentifiedWeaknesses(String playerId) {
    final profile = getPlayerProfile(playerId);
    if (profile.containsKey('improvementAreas')) {
      return List<String>.from(profile['improvementAreas'] ?? []);
    }
    // In a real implementation, this would analyze the player's data
    // For now, we'll return a sample list based on common weaknesses
    return ['tactics', 'endgame', 'calculation'];
  }

  /// Get player profile data with additional tracking information
  Map<String, dynamic> getPlayerProfile(String playerId) {
    // Get the base profile from the AI Coach
    final aiCoachProfile = _aiCoach.getPlayerProfile();
    
    // Return a map containing player-specific data
    return {
      'playerId': playerId,
      'improvementAreas': _improvementAreas.isEmpty && aiCoachProfile != null 
          ? aiCoachProfile.improvementAreas 
          : _improvementAreas,
      'strengths': _strengths,
      'completedTrainings': _completedTrainings.toList(),
      'rating': aiCoachProfile?.rating ?? 1200.0,
      'skillAreas': aiCoachProfile?.skillAreas ?? {},
    };
  }
}