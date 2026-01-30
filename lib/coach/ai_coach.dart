// lib/coach/ai_coach.dart
// Core AI Coach functionality

import 'dart:math';
import 'package:bellachess/coach/models.dart';
import 'package:bellachess/logic/chess_board.dart';
import 'package:bellachess/logic/move_calculation/move_classes/move.dart';
import 'package:bellachess/logic/move_calculation/move_calculation.dart';
import 'package:bellachess/logic/shared_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AICoach {
  static const String _playerProfileKey = 'coach_player_profile';
  static const List<String> _skillAreas = [
    'tactics',
    'strategy',
    'endgame',
    'openings',
    'calculation',
    'positional_play'
  ];

  PlayerProfile? _playerProfile;

  AICoach() {
    _loadPlayerProfile();
  }

  /// Load player profile from persistent storage
  Future<void> _loadPlayerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_playerProfileKey);
    
    if (profileJson != null) {
      // TODO: Implement JSON deserialization for PlayerProfile
      // For now, create a default profile
      _playerProfile = _createDefaultProfile();
    } else {
      _playerProfile = _createDefaultProfile();
      await _savePlayerProfile();
    }
  }

  /// Save player profile to persistent storage
  Future<void> _savePlayerProfile() async {
    if (_playerProfile != null) {
      final prefs = await SharedPreferences.getInstance();
      // TODO: Implement JSON serialization for PlayerProfile
      // prefs.setString(_playerProfileKey, jsonEncode(_playerProfile.toJson()));
    }
  }

  /// Create a default player profile
  PlayerProfile _createDefaultProfile() {
    final initialSkills = <String, double>{};
    for (final area in _skillAreas) {
      initialSkills[area] = 5.0; // Average skill level
    }

    return PlayerProfile(
      rating: 1200.0,
      skillAreas: initialSkills,
      gameHistory: [],
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );
  }

  /// Get the current player profile
  PlayerProfile? getPlayerProfile() {
    return _playerProfile;
  }

  /// Analyze a single move and return detailed analysis
  MoveAnalysis analyzeMove({
    required int moveNumber,
    required Move move,
    required ChessBoard board,
    required double evaluationBefore,
    required double evaluationAfter,
    required int maxDepth,
  }) {
    // Calculate the quality of the move based on evaluation change
    final moveQuality = _assessMoveQuality(evaluationBefore, evaluationAfter, board.currentPlayer);
    final alternatives = _findAlternatives(board, maxDepth);
    final explanation = _generateExplanation(moveQuality, move, board);

    return MoveAnalysis(
      moveNumber: moveNumber,
      move: move,
      evaluation: evaluationAfter,
      quality: moveQuality,
      alternatives: alternatives,
      explanation: explanation,
    );
  }

  /// Assess the quality of a move based on evaluation change
  MoveQuality _assessMoveQuality(double evalBefore, double evalAfter, Player? player) {
    // Determine if the evaluation change is from the perspective of the moving player
    // If player is white, positive eval is good; if black, negative eval is good
    final isWhite = player == Player.player1;
    final evalChange = isWhite ? evalAfter - evalBefore : evalBefore - evalAfter;
    
    // Define thresholds for different move qualities (in centipawns)
    const blunderThreshold = 300.0;
    const mistakeThreshold = 150.0;
    const inaccuracyThreshold = 50.0;
    
    if (evalChange <= -blunderThreshold) {
      return MoveQuality.blunder;
    } else if (evalChange <= -mistakeThreshold) {
      return MoveQuality.mistake;
    } else if (evalChange <= -inaccuracyThreshold) {
      return MoveQuality.inaccuracy;
    } else if (evalChange >= inaccuracyThreshold) {
      return MoveQuality.excellent;
    } else {
      return MoveQuality.good;
    }
  }

  /// Find alternative moves that might have been better
  List<String> _findAlternatives(ChessBoard board, int maxDepth) {
    final alternatives = <String>[];
    final moves = allMoves(board.currentPlayer, board, maxDepth);
    
    // Get evaluations for each move
    final moveEvaluations = <Move, double>{};
    for (final move in moves) {
      if (move != null) {
        push(move, board, promotionType: move.promotionType);
        final eval = boardValue(board);
        moveEvaluations[move] = eval;
        pop(board);
        
        // Add move to alternatives if it has a significantly better evaluation
        // than the actual move played
      }
    }
    
    // Sort moves by evaluation and return top alternatives
    final sortedMoves = moveEvaluations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    for (int i = 0; i < sortedMoves.length && i < 3; i++) {
      alternatives.add(_moveToSan(sortedMoves[i].key));
    }
    
    return alternatives;
  }

  /// Generate an explanation for a move based on its quality
  String _generateExplanation(MoveQuality quality, Move move, ChessBoard board) {
    String explanation = '';
    
    switch (quality) {
      case MoveQuality.excellent:
        explanation = 'Excellent choice! This move significantly improves your position.';
        break;
      case MoveQuality.good:
        explanation = 'Good move. You maintained your position well.';
        break;
      case MoveQuality.inaccuracy:
        explanation = 'This move was somewhat inaccurate. There were better options available.';
        break;
      case MoveQuality.mistake:
        explanation = 'This was a mistake that weakened your position.';
        break;
      case MoveQuality.blunder:
        explanation = 'This was a blunder that significantly harmed your position.';
        break;
    }
    
    // Add context-specific advice
    if (_isTacticalOpportunityMissed(board, move)) {
      explanation += ' You missed a tactical opportunity in this position.';
    }
    
    return explanation;
  }

  /// Check if a tactical opportunity was missed with the move played
  bool _isTacticalOpportunityMissed(ChessBoard board, Move move) {
    // Simple check: see if there was a capture available that wasn't taken
    final currentPlayer = board.currentPlayer;
    final possibleMoves = allMoves(currentPlayer, board, 3); // Shallow analysis
    
    for (final m in possibleMoves) {
      if (m != null && m.capturedPiece != null && m != move) {
        // There was a capture available that wasn't taken
        return true;
      }
    }
    
    return false;
  }

  /// Convert a move object to SAN (Standard Algebraic Notation)
  String _moveToSan(Move move) {
    // Simplified SAN conversion - a full implementation would be more complex
    String san = '';
    
    // Basic conversion (this is simplified - a full implementation would be much more complex)
    final fileNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    final rankNames = ['1', '2', '3', '4', '5', '6', '7', '8'];
    
    san += fileNames[move.from % 8] + rankNames[move.from ~/ 8];
    san += fileNames[move.to % 8] + rankNames[move.to ~/ 8];
    
    if (move.promotionType != null) {
      san += '=' + _pieceTypeToSymbol(move.promotionType!);
    }
    
    return san;
  }

  /// Convert piece type to symbol
  String _pieceTypeToSymbol(PieceType type) {
    switch (type) {
      case PieceType.pawn:
        return 'P';
      case PieceType.rook:
        return 'R';
      case PieceType.knight:
        return 'N';
      case PieceType.bishop:
        return 'B';
      case PieceType.queen:
        return 'Q';
      case PieceType.king:
        return 'K';
    }
  }

  /// Evaluate a position for complexity and tactical opportunities
  PositionEvaluation evaluatePosition(ChessBoard board, String fen) {
    // Count number of possible captures as indicator of tactical complexity
    final currentPlayer = board.currentPlayer;
    final possibleMoves = allMoves(currentPlayer, board, 3);
    int captureCount = 0;
    final tacticalMoves = <String>[];
    
    for (final move in possibleMoves) {
      if (move != null && move.capturedPiece != null) {
        captureCount++;
        tacticalMoves.add(_moveToSan(move));
      }
    }
    
    // Determine complexity based on capture count and other factors
    ComplexityRating complexity;
    if (captureCount >= 3) {
      complexity = ComplexityRating.critical;
    } else if (captureCount >= 2) {
      complexity = ComplexityRating.complex;
    } else if (captureCount >= 1) {
      complexity = ComplexityRating.moderate;
    } else {
      complexity = ComplexityRating.quiet;
    }
    
    // Determine position type (simplified)
    String positionType;
    final moveCount = board.moveCount;
    if (moveCount <= 10) {
      positionType = 'opening';
    } else if (moveCount <= 40) {
      positionType = 'middlegame';
    } else {
      positionType = 'endgame';
    }
    
    return PositionEvaluation(
      fen: fen,
      evaluation: boardValue(board),
      complexity: complexity,
      hasTacticalOpportunities: captureCount > 0,
      tacticalMoves: tacticalMoves,
      positionType: positionType,
    );
  }

  /// Generate improvement suggestions based on a game analysis
  ImprovementSuggestions generateImprovementSuggestions(GameAnalysis analysis) {
    final tacticalAreas = <String>[];
    final strategicAreas = <String>[];
    final recommendedEtudes = <String>[];
    
    // Analyze mistake patterns
    if (analysis.mistakeSummary.blunders > 2) {
      tacticalAreas.add('calculation');
      recommendedEtudes.add('basic_tactics');
    }
    
    if (analysis.mistakeSummary.mistakes > 3) {
      tacticalAreas.add('tactics');
      recommendedEtudes.add('intermediate_tactics');
    }
    
    // Check for specific weaknesses based on position types
    for (final moveAnalysis in analysis.moves) {
      // This would be expanded with more sophisticated pattern recognition
    }
    
    // Generate general advice
    String generalAdvice = 'Continue practicing. ';
    if (tacticalAreas.isNotEmpty) {
      generalAdvice += 'Focus on tactical exercises. ';
    }
    if (strategicAreas.isNotEmpty) {
      generalAdvice += 'Work on positional understanding. ';
    }
    
    if (analysis.mistakeSummary.averageCentipawnLoss > 50) {
      generalAdvice += 'Try to reduce blunders by taking more time on critical moves.';
    } else {
      generalAdvice += 'Good game! Keep up the good work.';
    }
    
    return ImprovementSuggestions(
      tacticalAreas: tacticalAreas,
      strategicAreas: strategicAreas,
      recommendedEtudes: recommendedEtudes,
      generalAdvice: generalAdvice,
    );
  }

  /// Calculate a new performance rating change after a game
  double calculateRatingChange(GameAnalysis analysis, double opponentRating) {
    // Simplified rating calculation based on performance
    // More accurate implementation would use Glicko or similar system
    
    final expectedScore = 1.0 / (1.0 + pow(10, (opponentRating - (_playerProfile?.rating ?? 1200.0)) / 400));
    final actualScore = _resultToScore(analysis.result);
    
    // K-factor determines how much the rating changes
    const kFactor = 32.0;
    
    return kFactor * (actualScore - expectedScore);
  }

  /// Convert game result to numeric score
  double _resultToScore(String result) {
    switch (result) {
      case 'win':
        return 1.0;
      case 'draw':
        return 0.5;
      case 'loss':
        return 0.0;
      default:
        return 0.0;
    }
  }

  /// Analyze an entire game and return a complete analysis
  Future<GameAnalysis> analyzeGame({
    required String gameId,
    required String result, // "win", "loss", "draw"
    required List<MoveAnalysis> moves,
    required double opponentRating,
  }) async {
    // Calculate mistake summary
    int blunders = 0;
    int mistakes = 0;
    int inaccuracies = 0;
    double totalCentipawnLoss = 0.0;
    
    for (final move in moves) {
      switch (move.quality) {
        case MoveQuality.blunder:
          blunders++;
          break;
        case MoveQuality.mistake:
          mistakes++;
          break;
        case MoveQuality.inaccuracy:
          inaccuracies++;
          break;
        default:
          // Other qualities don't count as mistakes
          break;
      }
      
      // Add to centipawn loss calculation (simplified)
      if (move.quality == MoveQuality.blunder) {
        totalCentipawnLoss += 300.0; // Approximate value
      } else if (move.quality == MoveQuality.mistake) {
        totalCentipawnLoss += 150.0;
      } else if (move.quality == MoveQuality.inaccuracy) {
        totalCentipawnLoss += 50.0;
      }
    }
    
    final avgCentipawnLoss = moves.isNotEmpty ? totalCentipawnLoss / moves.length : 0.0;
    
    final mistakeSummary = MistakeSummary(
      blunders: blunders,
      mistakes: mistakes,
      inaccuracies: inaccuracies,
      averageCentipawnLoss: avgCentipawnLoss,
    );
    
    final suggestions = generateImprovementSuggestions(
      GameAnalysis(
        gameId: gameId,
        timestamp: DateTime.now(),
        result: result,
        moves: moves,
        mistakeSummary: mistakeSummary,
        suggestions: ImprovementSuggestions(tacticalAreas: [], strategicAreas: [], recommendedEtudes: [], generalAdvice: ''),
        performanceRatingChange: 0.0, // Placeholder
        criticalPosition: null, // Would be calculated if needed
      ),
    );
    
    // Calculate rating change
    final ratingChange = calculateRatingChange(
      GameAnalysis(
        gameId: gameId,
        timestamp: DateTime.now(),
        result: result,
        moves: moves,
        mistakeSummary: mistakeSummary,
        suggestions: suggestions,
        performanceRatingChange: 0.0,
        criticalPosition: null,
      ),
      opponentRating
    );
    
    final gameAnalysis = GameAnalysis(
      gameId: gameId,
      timestamp: DateTime.now(),
      result: result,
      moves: moves,
      mistakeSummary: mistakeSummary,
      suggestions: suggestions,
      performanceRatingChange: ratingChange,
      criticalPosition: null, // Would identify most critical position if implemented
    );
    
    // Update player profile with this game
    if (_playerProfile != null) {
      _playerProfile!.updateWithGame(gameAnalysis);
      await _savePlayerProfile();
    }
    
    return gameAnalysis;
  }
}