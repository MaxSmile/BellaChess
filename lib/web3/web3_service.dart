// lib/web3/web3_service.dart
// Service for Web3 blockchain interactions

import 'dart:convert';
import 'dart:typed_data';
import 'package:bellachess/web3/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Web3Service {
  static const String _walletAddressKey = 'wallet_address';
  static const String _nftItemsKey = 'nft_items';
  static const String _pendingMintsKey = 'pending_nft_mints';

  String? _connectedWalletAddress;
  List<NFTItem> _nftItems = [];
  List<PendingNFTMint> _pendingMints = [];

  // Mock contract addresses for different NFT categories
  static const Map<NFTCategory, String> _contractAddresses = {
    NFTCategory.tournament: '0x1234567890123456789012345678901234567890',
    NFTCategory.achievement: '0x2345678901234567890123456789012345678901',
    NFTCategory.historical: '0x3456789012345678901234567890123456789012',
    NFTCategory.mastery: '0x4567890123456789012345678901234567890123',
    NFTCategory.ratingMilestone: '0x5678901234567890123456789012345678901234',
  };

  Web3Service() {
    _loadStoredData();
  }

  /// Load stored wallet address and NFT data
  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final walletAddress = prefs.getString(_walletAddressKey);
    if (walletAddress != null) {
      _connectedWalletAddress = walletAddress;
    }
    
    final nftItemsJson = prefs.getString(_nftItemsKey);
    if (nftItemsJson != null) {
      final nftItemsList = jsonDecode(nftItemsJson) as List;
      _nftItems = nftItemsList.map((item) => _fromJson(item)).toList();
    }
    
    final pendingMintsJson = prefs.getString(_pendingMintsKey);
    if (pendingMintsJson != null) {
      final pendingMintsList = jsonDecode(pendingMintsJson) as List;
      _pendingMints = pendingMintsList.map((item) => _pendingMintFromJson(item)).toList();
    }
  }

  /// Save wallet address to storage
  Future<void> _saveWalletAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_walletAddressKey, _connectedWalletAddress!);
  }

  /// Save NFT items to storage
  Future<void> _saveNFTItems() async {
    final prefs = await SharedPreferences.getInstance();
    final nftItemsJson = jsonEncode(_nftItems.map((item) => _toJson(item)).toList());
    await prefs.setString(_nftItemsKey, nftItemsJson);
  }

  /// Save pending mints to storage
  Future<void> _savePendingMints() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingMintsJson = jsonEncode(_pendingMints.map((item) => _pendingMintToJson(item)).toList());
    await prefs.setString(_pendingMintsKey, pendingMintsJson);
  }

  /// Connect to a wallet (mock implementation)
  Future<bool> connectWallet(String walletAddress) async {
    // In a real implementation, this would interact with a wallet provider
    // For now, we'll just store the address
    _connectedWalletAddress = walletAddress;
    await _saveWalletAddress();
    return true;
  }

  /// Disconnect from wallet
  Future<void> disconnectWallet() async {
    _connectedWalletAddress = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_walletAddressKey);
  }

  /// Check if wallet is connected
  bool get isWalletConnected => _connectedWalletAddress != null;

  /// Get connected wallet address
  String? get connectedWalletAddress => _connectedWalletAddress;

  /// Get all NFTs owned by the connected wallet
  List<NFTItem> getOwnedNFTs() {
    if (_connectedWalletAddress == null) return [];
    return _nftItems.where((nft) => nft.ownerAddress == _connectedWalletAddress).toList();
  }

  /// Get NFTs by category
  List<NFTItem> getNFTsByCategory(NFTCategory category) {
    return _nftItems.where((nft) => nft.category == category).toList();
  }

  /// Check if a specific NFT exists
  bool nftExists(String tokenId) {
    return _nftItems.any((nft) => nft.tokenId == tokenId);
  }

  /// Get a specific NFT by token ID
  NFTItem? getNFTById(String tokenId) {
    return _nftItems.firstWhere((nft) => nft.tokenId == tokenId, orElse: () => null);
  }

  /// Request to mint a new NFT
  Future<bool> requestMintNFT({
    required String playerId,
    required NFTCategory category,
    required NFTAttributes attributes,
    required String name,
    required String description,
    required String imageUrl,
    String? relatedEntityId,
  }) async {
    if (_connectedWalletAddress == null) {
      throw Exception('Wallet not connected');
    }

    // Create a pending mint request
    final pendingMint = PendingNFTMint(
      playerId: playerId,
      category: category,
      attributes: attributes,
      name: name,
      description: description,
      imageUrl: imageUrl,
      requestedAt: DateTime.now(),
      relatedEntityId: relatedEntityId,
    );

    _pendingMints.add(pendingMint);
    await _savePendingMints();

    // In a real implementation, this would interact with the smart contract
    // For now, we'll simulate a successful mint after a delay
    return _simulateMinting(pendingMint);
  }

  /// Simulate the minting process (mock implementation)
  Future<bool> _simulateMinting(PendingNFTMint pendingMint) async {
    // Generate a unique token ID
    final tokenId = '${pendingMint.category}_${DateTime.now().millisecondsSinceEpoch}';
    
    // Create the NFT item
    final nftItem = NFTItem(
      tokenId: tokenId,
      name: pendingMint.name,
      description: pendingMint.description,
      imageUrl: pendingMint.imageUrl,
      blockchainAddress: _contractAddresses[pendingMint.category]!,
      ownerAddress: _connectedWalletAddress!,
      metadataUri: 'ipfs://bafybeigdyrzt5sfp7udm7hu76uhjfb47w5wpukfhqdic7wwitfnwcgx7dq/${tokenId}',
      category: pendingMint.category,
      attributes: pendingMint.attributes,
      mintedAt: DateTime.now(),
      creatorAddress: _connectedWalletAddress!,
      royaltyPercentage: 0.05, // 5% royalty
      saleHistory: [],
    );

    // Add to owned NFTs
    _nftItems.add(nftItem);
    await _saveNFTItems();

    // Remove from pending mints
    _pendingMints.remove(pendingMint);
    await _savePendingMints();

    return true;
  }

  /// Get pending NFT mint requests
  List<PendingNFTMint> getPendingMints() {
    return _pendingMints;
  }

  /// Upload metadata to IPFS (mock implementation)
  Future<String> uploadMetadataToIPFS({
    required String name,
    required String description,
    required String imageUrl,
    required NFTAttributes attributes,
  }) async {
    // In a real implementation, this would upload to IPFS
    // For now, we'll return a mock IPFS hash
    return 'ipfs://bafybeigdyrzt5sfp7udm7hu76uhjfb47w5wpukfhqdic7wwitfnwcgx7dq/mock-metadata-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Get contract address for a category
  String getContractAddress(NFTCategory category) {
    return _contractAddresses[category]!;
  }

  /// Get total supply for a category
  int getTotalSupply(NFTCategory category) {
    return _nftItems.where((nft) => nft.category == category).length;
  }

  /// Check if a player has earned a specific type of NFT
  bool hasPlayerEarnedNFT(String playerId, NFTCategory category, {String? specificId}) {
    // In a real implementation, this would check for specific conditions
    // For now, we'll just check if the player has any NFTs in this category
    return _nftItems.any((nft) => 
      nft.category == category && 
      nft.creatorAddress.startsWith(playerId.substring(0, min(playerId.length, 10))));
  }

  /// Get NFTs for a specific player
  List<NFTItem> getNFTsForPlayer(String playerId) {
    // In a real implementation, this would match based on creatorAddress
    // For now, we'll use a simplified check
    return _nftItems.where((nft) => 
      nft.creatorAddress.startsWith(playerId.substring(0, min(playerId.length, 10)))).toList();
  }

  // Helper methods for JSON serialization
  Map<String, dynamic> _toJson(NFTItem nft) {
    return {
      'tokenId': nft.tokenId,
      'name': nft.name,
      'description': nft.description,
      'imageUrl': nft.imageUrl,
      'blockchainAddress': nft.blockchainAddress,
      'ownerAddress': nft.ownerAddress,
      'metadataUri': nft.metadataUri,
      'category': nft.category.toString(),
      'attributes': _attributesToJson(nft.attributes),
      'mintedAt': nft.mintedAt.millisecondsSinceEpoch,
      'creatorAddress': nft.creatorAddress,
      'royaltyPercentage': nft.royaltyPercentage,
      'saleHistory': nft.saleHistory.map((sale) => _saleToJson(sale)).toList(),
    };
  }

  NFTItem _fromJson(Map<String, dynamic> json) {
    return NFTItem(
      tokenId: json['tokenId'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      blockchainAddress: json['blockchainAddress'],
      ownerAddress: json['ownerAddress'],
      metadataUri: json['metadataUri'],
      category: _parseCategory(json['category']),
      attributes: _attributesFromJson(json['attributes']),
      mintedAt: DateTime.fromMillisecondsSinceEpoch(json['mintedAt']),
      creatorAddress: json['creatorAddress'],
      royaltyPercentage: json['royaltyPercentage'],
      saleHistory: (json['saleHistory'] as List).map((sale) => _saleFromJson(sale)).toList(),
    );
  }

  Map<String, dynamic> _attributesToJson(NFTAttributes attrs) {
    return {
      'ratingGained': attrs.ratingGained,
      'gameFen': attrs.gameFen,
      'gamePgn': attrs.gamePgn,
      'tournamentRank': attrs.tournamentRank,
      'etudeId': attrs.etudeId,
      'achievementType': attrs.achievementType,
      'tournamentId': attrs.tournamentId,
      'achievementDate': attrs.achievementDate?.millisecondsSinceEpoch,
    };
  }

  NFTAttributes _attributesFromJson(Map<String, dynamic> json) {
    return NFTAttributes(
      ratingGained: json['ratingGained'],
      gameFen: json['gameFen'],
      gamePgn: json['gamePgn'],
      tournamentRank: json['tournamentRank'],
      etudeId: json['etudeId'],
      achievementType: json['achievementType'],
      tournamentId: json['tournamentId'],
      achievementDate: json['achievementDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['achievementDate']) 
          : null,
    );
  }

  Map<String, dynamic> _saleToJson(NFTSale sale) {
    return {
      'transactionHash': sale.transactionHash,
      'buyerAddress': sale.buyerAddress,
      'sellerAddress': sale.sellerAddress,
      'price': sale.price,
      'timestamp': sale.timestamp.millisecondsSinceEpoch,
      'marketplace': sale.marketplace,
    };
  }

  NFTSale _saleFromJson(Map<String, dynamic> json) {
    return NFTSale(
      transactionHash: json['transactionHash'],
      buyerAddress: json['buyerAddress'],
      sellerAddress: json['sellerAddress'],
      price: json['price'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      marketplace: json['marketplace'],
    );
  }

  Map<String, dynamic> _pendingMintToJson(PendingNFTMint mint) {
    return {
      'playerId': mint.playerId,
      'category': mint.category.toString(),
      'attributes': _attributesToJson(mint.attributes),
      'name': mint.name,
      'description': mint.description,
      'imageUrl': mint.imageUrl,
      'requestedAt': mint.requestedAt.millisecondsSinceEpoch,
      'relatedEntityId': mint.relatedEntityId,
    };
  }

  PendingNFTMint _pendingMintFromJson(Map<String, dynamic> json) {
    return PendingNFTMint(
      playerId: json['playerId'],
      category: _parseCategory(json['category']),
      attributes: _attributesFromJson(json['attributes']),
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      requestedAt: DateTime.fromMillisecondsSinceEpoch(json['requestedAt']),
      relatedEntityId: json['relatedEntityId'],
    );
  }

  NFTCategory _parseCategory(String categoryStr) {
    switch (categoryStr) {
      case 'NFTCategory.tournament':
        return NFTCategory.tournament;
      case 'NFTCategory.achievement':
        return NFTCategory.achievement;
      case 'NFTCategory.historical':
        return NFTCategory.historical;
      case 'NFTCategory.mastery':
        return NFTCategory.mastery;
      case 'NFTCategory.ratingMilestone':
        return NFTCategory.ratingMilestone;
      default:
        return NFTCategory.achievement; // Default fallback
    }
  }
}

int min(int a, int b) => a < b ? a : b;