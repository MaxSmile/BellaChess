# Web3 NFT Integration Design

## Overview

The Web3 NFT Integration brings blockchain-based collectibles to the BellaChess platform. Players can earn, mint, and trade NFTs representing chess achievements, famous positions, and tournament victories. The system integrates with popular blockchains like Polygon to enable low-cost minting and trading.

## Components

### 1. NFT Marketplace
- **Minting Interface**: User-initiated NFT creation for achievements
- **Gallery Display**: Showcase earned collectibles
- **Trading Platform**: Peer-to-peer transfers (if permitted)
- **Metadata Standards**: IPFS storage for artwork and attributes

### 2. Smart Contracts
- **ERC-721 Compliance**: Standard NFT implementation
- **Minting Logic**: Rules for earning and creating NFTs
- **Royalty System**: Creator fees for secondary sales
- **Access Controls**: Role-based permissions for administrative functions

### 3. Achievement System
- **Tournament Victories**: NFTs for winning tournaments
- **Milestone Achievements**: NFTs for reaching rating milestones
- **Tactical Masteries**: NFTs for mastering specific etudes
- **Historical Positions**: NFTs for famous chess positions

### 4. Tournament System
- **Prize Pools**: USDT deposits with automatic distribution
- **Verification**: On-chain result confirmation
- **Escrow Mechanism**: Secure fund handling
- **Leaderboard**: Transparent ranking system

## Technical Implementation

### Data Models
```dart
class NFTItem {
  String tokenId;
  String name;
  String description;
  String imageUrl;
  String blockchainAddress; // Contract address
  String ownerAddress;
  String metadataUri; // IPFS hash
  NFTCategory category; // tournament, achievement, historical, etc.
  NFTAttributes attributes; // Ratings, moves, etc.
  DateTime mintedAt;
  String creatorAddress;
  double royaltyPercentage;
  List<NFTSale> saleHistory;
}

class NFTCategory {
  String id;
  String name;
  String description;
  String contractAddress; // Different contract per category
  String symbol;
  int totalSupply;
}

class NFTAttributes {
  int ratingGained; // Rating improvement associated with this NFT
  String? gameFen; // Position that led to earning this NFT
  String? gamePgn; // Full game that led to earning this NFT
  int? tournamentRank; // Rank in tournament that earned this NFT
  String? etudeId; // Etude mastered that earned this NFT
  String achievementType; // "tournament_win", "milestone", "mastery", etc.
}

class NFTSale {
  String transactionHash;
  String buyerAddress;
  String sellerAddress;
  double price; // In ETH/USDT
  DateTime timestamp;
  String marketplace; // OpenSea, Rarible, etc.
}

class NFTEarnRule {
  String id;
  String name;
  String description;
  NFTCategory category;
  Map<String, dynamic> conditions; // Conditions to earn this NFT
  String rewardTemplate; // Template for generating the NFT
  bool isActive;
  int maxSupply; // Maximum number that can be minted
}
```

### Web3 Integration Layer
- Wallet connection management
- Transaction signing and broadcasting
- Metadata generation and IPFS upload
- Smart contract interaction layer

### Achievement Tracking
- Criteria monitoring for NFT eligibility
- Automated minting triggers
- Verification and validation systems

## Implementation Plan

### Phase 1: Foundation Setup
1. Set up Web3 connection infrastructure
2. Create basic NFT data models
3. Implement wallet connection functionality
4. Set up smart contract interfaces

### Phase 2: Basic NFT Functionality
1. Implement NFT minting for basic achievements
2. Create NFT gallery display
3. Add metadata generation and IPFS upload
4. Implement basic marketplace functionality

### Phase 3: Advanced Features
1. Implement tournament-based NFT rewards
2. Add etude mastery NFTs
3. Create historical position NFTs
4. Implement trading functionality

### Phase 4: Advanced Marketplace
1. Integrate with existing NFT marketplaces
2. Implement royalty system
3. Add advanced filtering and search
4. Create NFT staking mechanisms

## Smart Contract Specifications

### BellaChessNFT.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BellaChessNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    struct NFTMetadata {
        string name;
        string description;
        string imageUrl;
        uint256 ratingGained;
        string gameFen;
        string achievementType;
        uint256 tournamentRank;
        string etudeId;
    }
    
    mapping(uint256 => NFTMetadata) private _tokenMetadata;
    mapping(address => bool) private _mintingPermissions; // Addresses allowed to mint
    
    event NFTMinted(uint256 indexed tokenId, address indexed to, string achievementType);
    event MintingPermissionGranted(address indexed addr);
    event MintingPermissionRevoked(address indexed addr);

    constructor() ERC721("BellaChessCollectible", "BCC") {}
    
    function setMintingPermission(address addr, bool allowed) external onlyOwner {
        _mintingPermissions[addr] = allowed;
        if (allowed) {
            emit MintingPermissionGranted(addr);
        } else {
            emit MintingPermissionRevoked(addr);
        }
    }
    
    function mintNFT(
        address to,
        string memory name,
        string memory description,
        string memory imageUrl,
        uint256 ratingGained,
        string memory gameFen,
        string memory achievementType,
        uint256 tournamentRank,
        string memory etudeId
    ) external returns (uint256) {
        require(_mintingPermissions[msg.sender], "Caller not authorized to mint");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        _safeMint(to, tokenId);
        
        _tokenMetadata[tokenId] = NFTMetadata({
            name: name,
            description: description,
            imageUrl: imageUrl,
            ratingGained: ratingGained,
            gameFen: gameFen,
            achievementType: achievementType,
            tournamentRank: tournamentRank,
            etudeId: etudeId
        });
        
        emit NFTMinted(tokenId, to, achievementType);
        return tokenId;
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        
        // In a real implementation, this would return a URI pointing to metadata
        // For now, returning an empty string - this would typically point to IPFS
        return "";
    }
    
    function getNFTMetadata(uint256 tokenId) external view returns (NFTMetadata memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenMetadata[tokenId];
    }
    
    // Override required functions
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
```

## Integration Points

### With Existing Code
- Extend `AppModel` to include Web3 connection state
- Integrate with existing achievement/tournament systems
- Connect with AI Coach and Etude systems for mastery tracking
- Use existing game data for NFT metadata

### With External Services
- Wallet connection libraries (e.g., web3modal, wagmi)
- IPFS for metadata storage
- Blockchain RPC endpoints
- NFT marketplace APIs

## Security Considerations

### Smart Contract Security
- Use OpenZeppelin standards and security practices
- Implement access controls for minting
- Prevent reentrancy attacks
- Perform proper input validation

### User Security
- Secure wallet connection flow
- Proper transaction signing
- Clear gas fee estimation
- Transaction confirmation requirements

## Success Metrics

### Technical Success
- Performance: <3s for NFT minting process
- Reliability: 99.9% uptime for Web3 interactions
- Scalability: Support for 100,000+ NFTs
- Integration: Seamless connection with existing features

### User Experience Success
- Adoption: 20% of active users mint at least one NFT
- Engagement: 15% increase in session time for NFT-enabled features
- Monetization: Revenue from tournament fees and royalties
- Satisfaction: Positive feedback on collectible features

## Risk Mitigation

### Technical Risks
- **Risk**: High gas fees making minting expensive
- **Mitigation**: Use Polygon or other low-cost chains, batch operations

- **Risk**: Smart contract vulnerabilities
- **Mitigation**: Thorough auditing, use established patterns, start with limited minting

### Market Risks
- **Risk**: Low user interest in NFTs
- **Mitigation**: Focus on utility and achievement recognition, not just speculation

### Regulatory Risks
- **Risk**: Changing regulations around NFTs
- **Mitigation**: Stay compliant, offer opt-in features, follow best practices