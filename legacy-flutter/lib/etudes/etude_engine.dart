// lib/etudes/etude_engine.dart
// Core engine for the Etude Challenge System

import 'package:bellachess/etudes/models.dart';
import 'package:bellachess/logic/chess_board.dart';
import 'package:bellachess/logic/move_calculation/move_calculation.dart';
import 'package:bellachess/logic/move_calculation/move_classes/move.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EtudeEngine {
  static const String _etudeProgressKey = 'etude_progress';
  static const String _etudeLibraryKey = 'etude_library';

  Map<String, EtudeProgress> _progressMap = {};
  List<Etude> _etudeLibrary = [];

  EtudeEngine() {
    _loadProgress();
    _initializeSampleEtudes();
  }

  /// Load player progress from persistent storage
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Implement proper serialization/deserialization
    // final progressJson = prefs.getString(_etudeProgressKey);
    // if (progressJson != null) {
    //   // Parse JSON into progress map
    // }
  }

  /// Save player progress to persistent storage
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Implement proper serialization
    // final progressJson = jsonEncode(_progressMap);
    // prefs.setString(_etudeProgressKey, progressJson);
  }

  /// Initialize with sample etudes for demonstration
  void _initializeSampleEtudes() {
    // Add some sample tactical puzzles
    _etudeLibrary.addAll([
      Etude(
        id: 'tac_001',
        title: 'Simple Fork',
        fen: 'rnbqkb1r/pppp1ppp/4pn2/8/1P6/5N2/PBPP1PPP/RN1QKB1R b KQkq - 0 4',
        solution: ['Nb4', 'Qa4+', 'Qxb4'], // Black plays Nb4, White responds Qa4+, Black captures Qxb4
        category: 'tactics',
        difficulty: 3,
        theme: 'fork',
        description: 'Knight fork: Attack two pieces simultaneously with your knight.',
        createdAt: DateTime(2023, 1, 15),
        author: 'BellaChess',
        tags: ['tactics', 'beginner', 'fork', 'knight'],
      ),
      Etude(
        id: 'tac_002',
        title: 'Discovery Attack',
        fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
        solution: ['Nd4', 'Nxd4', 'Bxd4'],
        category: 'tactics',
        difficulty: 4,
        theme: 'discovery',
        description: 'Discovery attack: Move a piece to reveal an attack from a long-range piece.',
        createdAt: DateTime(2023, 1, 15),
        author: 'BellaChess',
        tags: ['tactics', 'intermediate', 'discovery', 'bishop'],
      ),
      Etude(
        id: 'end_001',
        title: 'King Opposition',
        fen: '8/8/8/3k4/8/3K4/8/8 w - - 0 1',
        solution: ['Ke3', 'Kd5', 'Kf4', 'Kd4', 'Kf5'],
        category: 'endgame',
        difficulty: 5,
        theme: 'opposition',
        description: 'King opposition: Understanding the concept of opposition in king and pawn endgames.',
        createdAt: DateTime(2023, 1, 15),
        author: 'BellaChess',
        tags: ['endgame', 'advanced', 'opposition', 'king'],
      ),
      Etude(
        id: 'tac_003',
        title: 'Pin Example',
        fen: 'r1bqk2r/pppp1ppp/2n2n2/4p3/1bB1P3/2P2N2/PP1P1PPP/RNBQK2R w KQkq - 4 5',
        solution: ['Ng5', 'Bxd2+', 'Kxd2'],
        category: 'tactics',
        difficulty: 4,
        theme: 'pin',
        description: 'Relative pin: Pin an enemy piece that cannot legally move without exposing a more valuable piece.',
        createdAt: DateTime(2023, 1, 15),
        author: 'BellaChess',
        tags: ['tactics', 'intermediate', 'pin', 'bishop'],
      ),
    ]);
  }

  /// Get an etude by ID
  Etude? getEtudeById(String id) {
    return _etudeLibrary.firstWhere((etude) => etude.id == id, orElse: () => null);
  }

  /// Get all etudes in a category
  List<Etude> getEtudesByCategory(String category) {
    return _etudeLibrary.where((etude) => etude.category == category).toList();
  }

  /// Get all etudes by theme
  List<Etude> getEtudesByTheme(String theme) {
    return _etudeLibrary.where((etude) => etude.theme == theme).toList();
  }

  /// Get all etudes by difficulty range
  List<Etude> getEtudesByDifficulty(int minDifficulty, int maxDifficulty) {
    return _etudeLibrary
        .where((etude) => etude.difficulty >= minDifficulty && etude.difficulty <= maxDifficulty)
        .toList();
  }

  /// Get all available categories
  List<String> getCategories() {
    return _etudeLibrary.map((etude) => etude.category).toSet().toList();
  }

  /// Get all available themes
  List<String> getThemes() {
    return _etudeLibrary.map((etude) => etude.theme).toSet().toList();
  }

  /// Get a random etude from a category
  Etude? getRandomEtudeFromCategory(String category) {
    final etudes = getEtudesByCategory(category);
    if (etudes.isEmpty) return null;
    
    // For simplicity, returning the first one
    // In a real implementation, we'd use a random selection
    return etudes[0];
  }

  /// Get a recommended etude based on player progress
  Etude? getRecommendedEtude(String playerId) {
    // Find the player's weakest area based on progress
    final categoryStats = <String, List<double>>{}; // [avgRating, count]
    
    for (final progress in _progressMap.values.where((p) => p.playerId == playerId)) {
      final etude = getEtudeById(progress.etudeId);
      if (etude != null) {
        if (!categoryStats.containsKey(etude.category)) {
          categoryStats[etude.category] = [0, 0];
        }
        
        categoryStats[etude.category]![0] += progress.rating;
        categoryStats[etude.category]![1]++;
      }
    }
    
    // Find the category with the lowest average rating (weakest area)
    String weakestCategory = '';
    double lowestAvgRating = double.infinity;
    
    for (final entry in categoryStats.entries) {
      final avgRating = entry.value[0] / entry.value[1];
      if (avgRating < lowestAvgRating) {
        lowestAvgRating = avgRating;
        weakestCategory = entry.key;
      }
    }
    
    // If we couldn't find a weakest category, pick a random one
    if (weakestCategory.isEmpty) {
      final categories = getCategories();
      if (categories.isNotEmpty) {
        weakestCategory = categories[0]; // Simplified selection
      } else {
        return null;
      }
    }
    
    // Get etudes from the weakest category
    final etudes = getEtudesByCategory(weakestCategory);
    if (etudes.isEmpty) return null;
    
    // Return the first etude (in a real implementation, select based on difficulty matching player skill)
    return etudes[0];
  }

  /// Validate a move in the context of an etude
  bool validateMove({
    required String etudeId,
    required Move move,
    required int currentMoveIndex,
    required ChessBoard board,
  }) {
    final etude = getEtudeById(etudeId);
    if (etude == null) return false;
    
    // Get the expected move from the solution
    final expectedMove = etude.getCorrectMove(currentMoveIndex);
    if (expectedMove == null) return false;
    
    // Convert the move object to SAN notation for comparison
    // This is a simplified version - a full implementation would require proper SAN conversion
    final actualMoveSan = _moveToSan(move);
    
    return actualMoveSan == expectedMove;
  }

  /// Convert a move to SAN (Standard Algebraic Notation) - simplified version
  String _moveToSan(Move move) {
    // Simplified SAN conversion - a full implementation would be much more complex
    final fileNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    final rankNames = ['1', '2', '3', '4', '5', '6', '7', '8'];
    
    String san = '';
    
    // Basic move representation
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

  /// Get the next expected move in an etude
  String? getNextExpectedMove(String etudeId, int currentMoveIndex) {
    final etude = getEtudeById(etudeId);
    if (etude == null) return null;
    
    return etude.getCorrectMove(currentMoveIndex);
  }

  /// Get a hint for the current position in an etude
  EtudeHint? getHint(String etudeId, int currentMoveIndex) {
    final etude = getEtudeById(etudeId);
    if (etude == null) return null;
    
    final correctMove = etude.getCorrectMove(currentMoveIndex);
    if (correctMove == null) return null;
    
    // Generate a hint based on the correct move
    String hint = '';
    
    if (correctMove.contains('x')) {
      hint = 'This move involves capturing an opponent piece.';
    } else if (correctMove.contains('+')) {
      hint = 'This move puts the opponent\'s king in check.';
    } else if (correctMove.contains('#')) {
      hint = 'This move results in checkmate.';
    } else {
      hint = 'Consider the tactical motif: ${etude.theme}.';
    }
    
    return EtudeHint(
      moveIndex: currentMoveIndex,
      hint: hint,
      candidateMoves: _getCandidateMoves(etudeId, currentMoveIndex),
    );
  }

  /// Get candidate moves for the current position
  List<String> _getCandidateMoves(String etudeId, int currentMoveIndex) {
    final etude = getEtudeById(etudeId);
    if (etude == null) return [];
    
    // This would require setting up the board position and finding legal moves
    // For now, we'll return an empty list
    return [];
  }

  /// Record a player's attempt at solving an etude
  Future<void> recordAttempt({
    required String playerId,
    required String etudeId,
    required bool successful,
    required int solveTimeInSeconds,
  }) async {
    final progress = _progressMap['$playerId-$etudeId'];
    
    if (progress != null) {
      // Update existing progress
      _progressMap['$playerId-$etudeId'] = progress.updateAfterAttempt(
        successful: successful,
        solveTimeInSeconds: solveTimeInSeconds,
      );
    } else {
      // Create new progress record
      _progressMap['$playerId-$etudeId'] = EtudeProgress(
        playerId: playerId,
        etudeId: etudeId,
        attempts: 1,
        successes: successful ? 1 : 0,
        lastAttempt: DateTime.now(),
        firstSolved: successful ? DateTime.now() : null,
        solveTimes: successful ? [solveTimeInSeconds] : [],
        rating: successful ? 1210.0 : 1190.0, // Slightly adjust rating based on success
      );
    }
    
    await _saveProgress();
  }

  /// Get player's progress for a specific etude
  EtudeProgress? getProgressForEtude(String playerId, String etudeId) {
    return _progressMap['$playerId-$etudeId'];
  }

  /// Get all etudes that match a player's current skill level
  List<Etude> getEtudesForSkillLevel(String playerId, {int range = 1}) {
    // Get player's average performance rating
    double playerRating = 1200.0; // Default rating
    int count = 0;
    
    for (final progress in _progressMap.values.where((p) => p.playerId == playerId)) {
      playerRating += progress.rating;
      count++;
    }
    
    if (count > 0) {
      playerRating /= count;
    }
    
    // Convert rating to approximate difficulty level
    // This is a rough estimation - a real system would be more sophisticated
    final estimatedDifficulty = ((playerRating - 800) / 200).round().clamp(1, 10);
    
    // Get etudes within the difficulty range
    return getEtudesByDifficulty(
      (estimatedDifficulty - range).clamp(1, 10),
      (estimatedDifficulty + range).clamp(1, 10),
    );
  }

  /// Get statistics for a player
  Map<String, dynamic> getPlayerStats(String playerId) {
    final playerProgress = _progressMap.values.where((p) => p.playerId == playerId);
    
    int totalEtudes = 0;
    int masteredEtudes = 0;
    int totalAttempts = 0;
    int totalSuccesses = 0;
    double averageRating = 0.0;
    
    for (final progress in playerProgress) {
      totalEtudes++;
      if (progress.mastered) masteredEtudes++;
      totalAttempts += progress.attempts;
      totalSuccesses += progress.successes;
      averageRating += progress.rating;
    }
    
    if (totalEtudes > 0) {
      averageRating /= totalEtudes;
    }
    
    final successRate = totalAttempts > 0 ? (totalSuccesses / totalAttempts) * 100 : 0.0;
    
    return {
      'totalEtudes': totalEtudes,
      'masteredEtudes': masteredEtudes,
      'totalAttempts': totalAttempts,
      'totalSuccesses': totalSuccesses,
      'successRate': successRate,
      'averageRating': averageRating,
      'masteredPercentage': totalEtudes > 0 ? (masteredEtudes / totalEtudes) * 100 : 0.0,
    };
  }
  
  /// Get all etudes in the library
  List<Etude> getAllEtudes() {
    return _etudeLibrary;
  }

  /// Get etudes that target a specific weakness
  List<Etude> getEtudesForWeakness(String weakness) {
    return _etudeLibrary.where((etude) => 
        etude.theme.toLowerCase().contains(weakness.toLowerCase()) || 
        etude.tags.any((tag) => tag.toLowerCase().contains(weakness.toLowerCase()))
    ).toList();
  }
}