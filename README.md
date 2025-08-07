# EcoReward 🌱

A blockchain-based sustainability incentive platform that rewards users for eco-friendly actions, tracks environmental impact, and issues NFT certificates for significant milestones.

## Overview

EcoReward is a Clarity smart contract built on the Stacks blockchain that gamifies environmental responsibility by rewarding users with ECO tokens for verified eco-friendly actions. The platform creates a transparent, decentralized system for tracking and incentivizing positive environmental behavior, now enhanced with unique NFT certificates for milestone achievements.

## Features

- **Token-Based Rewards**: Earn ECO tokens for verified eco-friendly actions
- **Impact Tracking**: Track personal and collective environmental impact scores
- **NFT Certificates**: Receive unique certificates for reaching environmental milestones
- **Verified Actions**: Decentralized verification system with authorized verifiers
- **Multiple Action Types**: Support for various eco-friendly activities (recycling, tree planting, solar energy, etc.)
- **User Statistics**: Comprehensive tracking of user participation and rewards
- **Milestone System**: Achievement-based progression with certificate rewards
- **Transparent Governance**: On-chain action type management and reward calculations

## How It Works

1. **Submit Action**: Users submit eco-friendly actions with impact scores
2. **Verification**: Authorized verifiers confirm the authenticity of actions
3. **Reward Distribution**: Verified actions automatically trigger token rewards
4. **Impact Tracking**: System tracks cumulative environmental impact
5. **Milestone Achievement**: Users earn NFT certificates for reaching significant milestones

## Action Types

- **Recycling**: Base reward 100 ECO, 2x impact multiplier
- **Tree Planting**: Base reward 500 ECO, 10x impact multiplier
- **Solar Energy**: Base reward 300 ECO, 5x impact multiplier
- **Bike Commuting**: Base reward 50 ECO, 1x impact multiplier
- **Composting**: Base reward 75 ECO, 2x impact multiplier

## NFT Certificate Milestones

- **Eco Warrior**: 50+ verified eco-friendly actions
- **Impact Champion**: 1,000+ total impact points
- **Green Pioneer**: 10,000+ ECO tokens earned

## Technical Specifications

- **Token**: ECO (EcoReward Token)
- **NFT**: ECOCERT (EcoReward Certificate)
- **Decimals**: 6
- **Blockchain**: Stacks
- **Language**: Clarity
- **Architecture**: Single contract with comprehensive state management

## Getting Started

### Prerequisites

- Clarinet CLI
- Stacks wallet
- Basic understanding of Clarity smart contracts

### Installation

1. Clone the repository
2. Install dependencies: `clarinet requirements`
3. Check contract: `clarinet check`
4. Deploy locally: `clarinet console`

### Usage

```clarity
;; Initialize action types and milestones (owner only)
(contract-call? .ecoreward initialize-action-types)

;; Submit an eco action
(contract-call? .ecoreward submit-eco-action "recycling" u10)

;; Verify an action (verifier only)
(contract-call? .ecoreward verify-eco-action u1)

;; Claim milestone certificate
(contract-call? .ecoreward claim-certificate "eco-warrior")

;; Check balance
(contract-call? .ecoreward get-balance-of tx-sender)

;; Check certificate status
(contract-call? .ecoreward has-certificate tx-sender "eco-warrior")
```

## Contract Functions

### Public Functions

- `initialize-action-types()`: Set up default action types and milestones
- `add-action-type(action-type, base-reward, impact-multiplier)`: Add new action type
- `add-milestone(milestone-type, threshold)`: Add new milestone threshold
- `add-verifier(verifier)`: Add authorized verifier
- `submit-eco-action(action-type, impact-score)`: Submit eco-friendly action
- `verify-eco-action(action-id)`: Verify submitted action
- `claim-certificate(milestone-type)`: Claim milestone achievement certificate
- `transfer(amount, recipient)`: Transfer ECO tokens

### Read-Only Functions

- `get-token-info()`: Get token information
- `get-nft-info()`: Get NFT certificate information
- `get-balance-of(user)`: Get user's token balance
- `get-eco-action(action-id)`: Get action details
- `get-action-type-info(action-type)`: Get action type configuration
- `get-user-stats(user)`: Get user statistics
- `get-total-supply()`: Get total token supply
- `is-verifier(verifier)`: Check if address is authorized verifier
- `get-certificate(certificate-id)`: Get certificate details
- `get-milestone-threshold(milestone-type)`: Get milestone threshold
- `has-certificate(user, milestone-type)`: Check if user has specific certificate
- `check-milestone-status(user, milestone-type)`: Check milestone eligibility

## Security Features

- Owner-only administrative functions
- Verifier authorization system
- Input validation and error handling
- Protection against double-claiming
- Certificate uniqueness validation
- Secure token minting and transfers

## Error Codes

- `u100`: Owner only access
- `u101`: Resource not found
- `u102`: Resource already exists
- `u103`: Invalid amount
- `u104`: Insufficient balance
- `u105`: Invalid action type
- `u106`: Unauthorized access
- `u107`: Action already claimed
- `u108`: Invalid verifier
- `u109`: Milestone not reached
- `u110`: Certificate already issued

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `clarinet test`
5. Submit a pull request

*Building a sustainable future, one action at a time.* 🌍