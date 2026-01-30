// lib/web3/models.dart
// Data models for the Web3 NFT Integration

import 'package:bellachess/etudes/models.dart';
import 'package:bellachess/coach/models.dart';

/// Types of NFT categories
enum NFTCategory {
  tournament,
  achievement,
  historical,
  mastery,
  ratingMilestone,
}

/// Represents an NFT item in the BellaChess collection
class NFTItem {
  final String tokenId;
  final String name;
  final String description;
  final String imageUrl;
  final String blockchainAddress; // Contract address
  final String ownerAddress;
  final String metadataUri; // IPFS hash or URL
  final NFTCategory category;
  final NFTAttributes attributes;
  final DateTime mintedAt;
  final String creatorAddress;
  final double royaltyPercentage;
  final List<NFTSale> saleHistory;

  NFTItem({
    required this.tokenId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.blockchainAddress,
    required this.ownerAddress,
    required this.metadataUri,
    required this.category,
    required this.attributes,
    required this.mintedAt,
    required this.creatorAddress,
    required this.royaltyPercentage,
    required this.saleHistory,
  });

  /// Check if this NFT was earned through tournament victory
  bool get isTournamentNFT => category == NFTCategory.tournament;

  /// Check if this NFT represents an achievement
  bool get isAchievementNFT => category == NFTCategory.achievement;

  /// Check if this NFT represents a historical position
  bool get isHistoricalNFT => category == NFTCategory.historical;

  /// Check if this NFT represents mastery of an etude
  bool get isMasteryNFT => category == NFTCategory.mastery;

  /// Check if this NFT represents a rating milestone
  bool get isRatingMilestoneNFT => category == NFTCategory.ratingMilestone;
}

/// Attributes specific to each NFT
class NFTAttributes {
  final int? ratingGained; // Rating improvement associated with this NFT
  final String? gameFen; // Position that led to earning this NFT
  final String? gamePgn; // Full game that led to earning this NFT
  final int? tournamentRank; // Rank in tournament that earned this NFT
  final String? etudeId; // Etude mastered that earned this NFT
  final String achievementType; // "tournament_win", "milestone", "mastery", etc.
  final String? tournamentId; // ID of tournament that earned this NFT
  final DateTime? achievementDate; // Date when achievement was earned

  NFTAttributes({
    this.ratingGained,
    this.gameFen,
    this.gamePgn,
    this.tournamentRank,
    this.etudeId,
    required this.achievementType,
    this.tournamentId,
    this.achievementDate,
  });

  /// Create attributes for a tournament victory NFT
  factory NFTAttributes.forTournament({
    required int rank,
    required String tournamentId,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
  }) {
    return NFTAttributes(
      tournamentRank: rank,
      tournamentId: tournamentId,
      gameFen: gameFen,
      gamePgn: gamePgn,
      ratingGained: ratingGained,
      achievementType: 'tournament_win',
      achievementDate: DateTime.now(),
    );
  }

  /// Create attributes for an achievement NFT
  factory NFTAttributes.forAchievement({
    required String achievementType,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
  }) {
    return NFTAttributes(
      achievementType: achievementType,
      gameFen: gameFen,
      gamePgn: gamePgn,
      ratingGained: ratingGained,
      achievementDate: DateTime.now(),
    );
  }

  /// Create attributes for a mastery NFT
  factory NFTAttributes.forMastery({
    required String etudeId,
    String? gameFen,
    String? gamePgn,
    int? ratingGained,
  }) {
    return NFTAttributes(
      etudeId: etudeId,
      gameFen: gameFen,
      gamePgn: gamePgn,
      ratingGained: ratingGained,
      achievementType: 'mastery',
      achievementDate: DateTime.now(),
    );
  }

  /// Create attributes for a rating milestone NFT
  factory NFTAttributes.forRatingMilestone({
    required int ratingGained,
    String? gameFen,
    String? gamePgn,
  }) {
    return NFTAttributes(
      ratingGained: ratingGained,
      gameFen: gameFen,
      gamePgn: gamePgn,
      achievementType: 'rating_milestone',
      achievementDate: DateTime.now(),
    );
  }
}

/// Represents a sale of an NFT
class NFTSale {
  final String transactionHash;
  final String buyerAddress;
  final String sellerAddress;
  final double price; // In ETH/USDT
  final DateTime timestamp;
  final String marketplace; // OpenSea, Rarible, etc.

  NFTSale({
    required this.transactionHash,
    required this.buyerAddress,
    required this.sellerAddress,
    required this.price,
    required this.timestamp,
    required this.marketplace,
  });
}

/// Represents an NFT category
class NFTCategoryInfo {
  final String id;
  final String name;
  final String description;
  final String contractAddress; // Different contract per category
  final String symbol;
  final int totalSupply;

  NFTCategoryInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.contractAddress,
    required this.symbol,
    required this.totalSupply,
  });
}

/// Rule defining when an NFT can be earned
class NFTEarnRule {
  final String id;
  final String name;
  final String description;
  final NFTCategory category;
  final Map<String, dynamic> conditions; // Conditions to earn this NFT
  final String rewardTemplate; // Template for generating the NFT
  final bool isActive;
  final int maxSupply; // Maximum number that can be minted

  NFTEarnRule({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.conditions,
    required this.rewardTemplate,
    required this.isActive,
    required this.maxSupply,
  });

  /// Check if the conditions are met for this rule
  bool checkConditions(Map<String, dynamic> playerData) {
    // This is a simplified check - a real implementation would be more complex
    for (final condition in conditions.entries) {
      if (!playerData.containsKey(condition.key) ||
          playerData[condition.key] != condition.value) {
        return false;
      }
    }
    return true;
  }
}

/// Represents a pending NFT mint request
class PendingNFTMint {
  final String playerId;
  final NFTCategory category;
  final NFTAttributes attributes;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime requestedAt;
  final String? relatedEntityId; // ID of related entity (game, tournament, etc.)

  PendingNFTMint({
    required this.playerId,
    required this.category,
    required this.attributes,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.requestedAt,
    this.relatedEntityId,
  });
}