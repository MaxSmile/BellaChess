// lib/etudes/etude_service.dart
// Service layer to integrate Etude Engine with the app

import 'package:bellachess/etudes/etude_engine.dart';
import 'package:bellachess/etudes/models.dart';
import 'package:bellachess/logic/chess_board.dart';
import 'package:bellachess/logic/move_calculation/move_classes/move.dart';

class EtudeService {
  final EtudeEngine _engine = EtudeEngine();

  /// Get an etude by ID
  Etude? getEtudeById(String id) {
    return _engine.getEtudeById(id);
  }

  /// Get all etudes in a category
  List<Etude> getEtudesByCategory(String category) {
    return _engine.getEtudesByCategory(category);
  }

  /// Get all etudes by theme
  List<Etude> getEtudesByTheme(String theme) {
    return _engine.getEtudesByTheme(theme);
  }

  /// Get all etudes by difficulty range
  List<Etude> getEtudesByDifficulty(int minDifficulty, int maxDifficulty) {
    return _engine.getEtudesByDifficulty(minDifficulty, maxDifficulty);
  }

  /// Get all available categories
  List<String> getCategories() {
    return _engine.getCategories();
  }

  /// Get all available themes
  List<String> getThemes() {
    return _engine.getThemes();
  }

  /// Get a random etude from a category
  Etude? getRandomEtudeFromCategory(String category) {
    return _engine.getRandomEtudeFromCategory(category);
  }

  /// Get a recommended etude based on player progress
  Etude? getRecommendedEtude(String playerId) {
    return _engine.getRecommendedEtude(playerId);
  }

  /// Validate a move in the context of an etude
  bool validateMove({
    required String etudeId,
    required Move move,
    required int currentMoveIndex,
    required ChessBoard board,
  }) {
    return _engine.validateMove(
      etudeId: etudeId,
      move: move,
      currentMoveIndex: currentMoveIndex,
      board: board,
    );
  }

  /// Get the next expected move in an etude
  String? getNextExpectedMove(String etudeId, int currentMoveIndex) {
    return _engine.getNextExpectedMove(etudeId, currentMoveIndex);
  }

  /// Get a hint for the current position in an etude
  EtudeHint? getHint(String etudeId, int currentMoveIndex) {
    return _engine.getHint(etudeId, currentMoveIndex);
  }

  /// Record a player's attempt at solving an etude
  Future<void> recordAttempt({
    required String playerId,
    required String etudeId,
    required bool successful,
    required int solveTimeInSeconds,
  }) async {
    await _engine.recordAttempt(
      playerId: playerId,
      etudeId: etudeId,
      successful: successful,
      solveTimeInSeconds: solveTimeInSeconds,
    );
  }

  /// Get player's progress for a specific etude
  EtudeProgress? getProgressForEtude(String playerId, String etudeId) {
    return _engine.getProgressForEtude(playerId, etudeId);
  }

  /// Get all etudes that match a player's current skill level
  List<Etude> getEtudesForSkillLevel(String playerId, {int range = 1}) {
    return _engine.getEtudesForSkillLevel(playerId, range: range);
  }

  /// Get statistics for a player
  Map<String, dynamic> getPlayerStats(String playerId) {
    return _engine.getPlayerStats(playerId);
  }

  /// Get the full etude library
  List<Etude> getFullLibrary() {
    // Access the internal library through a getter method
    return _engine.getAllEtudes();
  }

  /// Mark an etude as completed by a player
  Future<void> markEtudeCompleted(String playerId, String etudeId, bool mastered) async {
    // Record the attempt which tracks completion
    await recordAttempt(
      playerId: playerId,
      etudeId: etudeId,
      successful: mastered,
      solveTimeInSeconds: 0, // Placeholder
    );
  }

  /// Get etudes that target a specific weakness
  List<Etude> getEtudesForWeakness(String weakness) {
    final allEtudes = getFullLibrary();
    return allEtudes.where((etude) => 
        etude.theme.toLowerCase().contains(weakness.toLowerCase()) || 
        etude.tags.any((tag) => tag.toLowerCase().contains(weakness.toLowerCase()))
    ).toList();
  }
}