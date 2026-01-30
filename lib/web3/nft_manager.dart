// lib/web3/nft_manager.dart
// Manager for NFT minting and tracking

import 'package:bellachess/web3/models.dart';
import 'package:bellachess/web3/web3_service.dart';
import 'package:bellachess/etudes/models.dart';
import 'package:bellachess/coach/models.dart';

class NFTManager {
  final Web3Service _web3Service;
  
  NFTManager(this._web3Service);

  /// Award an NFT for tournament participation or victory
  Future<bool> awardTournamentNFT({
    required String playerId,
    required String tournamentId,
    required String playerName,
    required int rank,
    required int totalParticipants,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
  }) async {
    if (!_web3Service.isWalletConnected) {
      return false; // Can't mint without a connected wallet
    }

    final name = rank == 1 
        ? 'Tournament Champion: $tournamentId' 
        : 'Tournament Participant: $tournamentId';
    
    final description = rank == 1
        ? 'Awarded for winning tournament $tournamentId with $totalParticipants participants'
        : 'Awarded for participating in tournament $tournamentId and finishing in rank #$rank of $totalParticipants';
    
    final imageUrl = rank == 1
        ? 'https://bellachess.org/nfts/tournament-champion.png'
        : 'https://bellachess.org/nfts/tournament-participant.png';

    final attributes = NFTAttributes.forTournament(
      rank: rank,
      tournamentId: tournamentId,
      gameFen: gameFen,
      gamePgn: gamePgn,
      ratingGained: ratingGained,
    );

    return await _web3Service.requestMintNFT(
      playerId: playerId,
      category: NFTCategory.tournament,
      attributes: attributes,
      name: name,
      description: description,
      imageUrl: imageUrl,
      relatedEntityId: tournamentId,
    );
  }

  /// Award an NFT for achieving a rating milestone
  Future<bool> awardRatingMilestoneNFT({
    required String playerId,
    required double newRating,
    required double previousRating,
    String? gameFen,
    String? gamePgn,
  }) async {
    if (!_web3Service.isWalletConnected) {
      return false;
    }

    // Determine the milestone based on rating
    final int milestoneRating = _getRatingMilestone(newRating);
    if (milestoneRating <= _getRatingMilestone(previousRating)) {
      // Player hasn't reached a new milestone
      return false;
    }

    final name = 'Rating Milestone: ${milestoneRating.toInt()}';
    final description = 'Awarded for achieving a rating of ${milestoneRating.toInt()}';
    final imageUrl = 'https://bellachess.org/nfts/rating-milestone-${milestoneRating.toInt()}.png';

    final attributes = NFTAttributes.forRatingMilestone(
      ratingGained: milestoneRating.toInt(),
      gameFen: gameFen,
      gamePgn: gamePgn,
    );

    return await _web3Service.requestMintNFT(
      playerId: playerId,
      category: NFTCategory.ratingMilestone,
      attributes: attributes,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }

  /// Award an NFT for mastering an etude
  Future<bool> awardMasteryNFT({
    required String playerId,
    required Etude etude,
    required String playerName,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
  }) async {
    if (!_web3Service.isWalletConnected) {
      return false;
    }

    final name = 'Etude Master: ${etude.title}';
    final description = 'Awarded for mastering the "${etude.title}" etude (${etude.theme} theme)';
    final imageUrl = 'https://bellachess.org/nfts/etude-master-${etude.id}.png';

    final attributes = NFTAttributes.forMastery(
      etudeId: etude.id,
      gameFen: gameFen,
      gamePgn: gamePgn,
      ratingGained: ratingGained,
    );

    return await _web3Service.requestMintNFT(
      playerId: playerId,
      category: NFTCategory.mastery,
      attributes: attributes,
      name: name,
      description: description,
      imageUrl: imageUrl,
      relatedEntityId: etude.id,
    );
  }

  /// Award an NFT for a significant achievement
  Future<bool> awardAchievementNFT({
    required String playerId,
    required String achievementType,
    required String achievementName,
    required String achievementDescription,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
    String? relatedEntityId,
  }) async {
    if (!_web3Service.isWalletConnected) {
      return false;
    }

    final name = achievementName;
    final description = achievementDescription;
    final imageUrl = 'https://bellachess.org/nfts/achievement-${achievementType.toLowerCase()}.png';

    final attributes = NFTAttributes.forAchievement(
      achievementType: achievementType,
      gameFen: gameFen,
      gamePgn: gamePgn,
      ratingGained: ratingGained,
    );

    return await _web3Service.requestMintNFT(
      playerId: playerId,
      category: NFTCategory.achievement,
      attributes: attributes,
      name: name,
      description: description,
      imageUrl: imageUrl,
      relatedEntityId: relatedEntityId,
    );
  }

  /// Award an NFT for a historical position or famous game
  Future<bool> awardHistoricalNFT({
    required String playerId,
    required String positionTitle,
    required String positionDescription,
    required String fen,
    String? pgn,
    String? relatedEntityId,
  }) async {
    if (!_web3Service.isWalletConnected) {
      return false;
    }

    final name = 'Historical Position: $positionTitle';
    final description = positionDescription;
    final imageUrl = 'https://bellachess.org/nfts/historical-position-${positionTitle.toLowerCase().replaceAll(' ', '-')}.png';

    final attributes = NFTAttributes(
      gameFen: fen,
      gamePgn: pgn,
      achievementType: 'historical_position',
    );

    return await _web3Service.requestMintNFT(
      playerId: playerId,
      category: NFTCategory.historical,
      attributes: attributes,
      name: name,
      description: description,
      imageUrl: imageUrl,
      relatedEntityId: relatedEntityId,
    );
  }

  /// Check if a player has already earned a specific NFT type
  bool hasPlayerEarnedNFT(String playerId, NFTCategory category, {String? specificId}) {
    return _web3Service.hasPlayerEarnedNFT(playerId, category, specificId: specificId);
  }

  /// Get all NFTs for a specific player
  List<NFTItem> getNFTsForPlayer(String playerId) {
    return _web3Service.getNFTsForPlayer(playerId);
  }

  /// Get all owned NFTs by the connected wallet
  List<NFTItem> getOwnedNFTs() {
    return _web3Service.getOwnedNFTs();
  }

  /// Get NFTs by category
  List<NFTItem> getNFTsByCategory(NFTCategory category) {
    return _web3Service.getNFTsByCategory(category);
  }

  /// Get the rating milestone for a given rating
  int _getRatingMilestone(double rating) {
    // Round down to nearest 100
    return (rating / 100).floor() * 100;
  }

  /// Get pending NFT mint requests
  List<PendingNFTMint> getPendingMints() {
    return _web3Service.getPendingMints();
  }
}