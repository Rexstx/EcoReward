# EcoReward 🌱

A blockchain-based sustainability incentive platform that rewards users for eco-friendly actions, tracks environmental impact, issues NFT certificates for significant milestones, and features an integrated marketplace for eco-friendly products and services.

## Overview

EcoReward is a Clarity smart contract built on the Stacks blockchain that gamifies environmental responsibility by rewarding users with ECO tokens for verified eco-friendly actions. The platform creates a transparent, decentralized system for tracking and incentivizing positive environmental behavior, enhanced with unique NFT certificates for milestone achievements and a comprehensive marketplace where users can spend their earned tokens on sustainable products and services.

## Features

- **Token-Based Rewards**: Earn ECO tokens for verified eco-friendly actions
- **Impact Tracking**: Track personal and collective environmental impact scores
- **NFT Certificates**: Receive unique certificates for reaching environmental milestones
- **Integrated Marketplace**: Spend ECO tokens on eco-friendly products and services
- **Verified Merchants**: Trusted sellers offering sustainable goods and services
- **Verified Actions**: Decentralized verification system with authorized verifiers
- **Multiple Action Types**: Support for various eco-friendly activities (recycling, tree planting, solar energy, etc.)
- **User Statistics**: Comprehensive tracking of user participation, rewards, and spending
- **Milestone System**: Achievement-based progression with certificate rewards
- **Transparent Governance**: On-chain action type management and reward calculations

## How It Works

1. **Submit Action**: Users submit eco-friendly actions with impact scores
2. **Verification**: Authorized verifiers confirm the authenticity of actions
3. **Reward Distribution**: Verified actions automatically trigger token rewards
4. **Impact Tracking**: System tracks cumulative environmental impact
5. **Milestone Achievement**: Users earn NFT certificates for reaching significant milestones
6. **Marketplace Shopping**: Users can spend earned ECO tokens on sustainable products and services

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

## Marketplace Categories

- **Solar**: Solar panels, batteries, and renewable energy equipment
- **Transportation**: Electric bikes, scooters, and sustainable transport solutions
- **Food**: Organic, local, and sustainable food products
- **Clothing**: Eco-friendly apparel and sustainable fashion
- **Home**: Green home products and energy-efficient appliances
- **Garden**: Organic gardening supplies and sustainable landscaping
- **Services**: Environmental consultations and green services

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

;; Add verified merchant (owner only)
(contract-call? .ecoreward add-merchant 'SP1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)

;; Create marketplace listing (merchant only)
(contract-call? .ecoreward create-listing 
  "Solar Panel Kit" 
  "High-efficiency 100W solar panel with battery pack" 
  "solar" 
  u5000)

;; Purchase from marketplace
(contract-call? .ecoreward purchase-item u1)

;; Check balance
(contract-call? .ecoreward get-balance-of tx-sender)

;; Check certificate status
(contract-call? .ecoreward has-certificate tx-sender "eco-warrior")

;; Get marketplace info
(contract-call? .ecoreward get-marketplace-info)
```

## Contract Functions

### Public Functions

- `initialize-action-types()`: Set up default action types and milestones
- `add-action-type(action-type, base-reward, impact-multiplier)`: Add new action type
- `add-milestone(milestone-type, threshold)`: Add new milestone threshold
- `add-verifier(verifier)`: Add authorized verifier
- `add-merchant(merchant)`: Add authorized marketplace merchant
- `submit-eco-action(action-type, impact-score)`: Submit eco-friendly action
- `verify-eco-action(action-id)`: Verify submitted action
- `claim-certificate(milestone-type)`: Claim milestone achievement certificate
- `create-listing(title, description, category, price)`: Create marketplace listing
- `update-listing(listing-id, title, description, category, price)`: Update listing
- `deactivate-listing(listing-id)`: Deactivate marketplace listing
- `purchase-item(listing-id)`: Purchase item from marketplace
- `transfer(amount, recipient)`: Transfer ECO tokens

### Read-Only Functions

- `get-token-info()`: Get token information
- `get-nft-info()`: Get NFT certificate information
- `get-marketplace-info()`: Get marketplace statistics
- `get-balance-of(user)`: Get user's token balance
- `get-eco-action(action-id)`: Get action details
- `get-action-type-info(action-type)`: Get action type configuration
- `get-user-stats(user)`: Get user statistics including spending
- `get-total-supply()`: Get total token supply
- `is-verifier(verifier)`: Check if address is authorized verifier
- `is-merchant(merchant)`: Check if address is authorized merchant
- `get-certificate(certificate-id)`: Get certificate details
- `get-milestone-threshold(milestone-type)`: Get milestone threshold
- `has-certificate(user, milestone-type)`: Check if user has specific certificate
- `check-milestone-status(user, milestone-type)`: Check milestone eligibility
- `get-listing(listing-id)`: Get marketplace listing details
- `get-purchase(purchase-id)`: Get purchase transaction details

## Security Features

- Owner-only administrative functions
- Verifier and merchant authorization systems
- Input validation and error handling
- Protection against double-claiming and self-purchasing
- Certificate uniqueness validation
- Secure token minting, transfers, and marketplace transactions
- Category validation for marketplace listings

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
- `u111`: Invalid listing
- `u112`: Listing not active
- `u113`: Cannot buy own listing
- `u114`: Invalid merchant

## Marketplace Integration Benefits

- **Circular Economy**: Users earn tokens through eco-actions and spend them on sustainable products
- **Vendor Incentives**: Merchants are motivated to offer eco-friendly products to access the ECO token ecosystem
- **User Engagement**: Provides practical utility for earned tokens, increasing platform stickiness
- **Environmental Impact**: Channels spending toward sustainable products and services
- **Community Building**: Creates a network of environmentally conscious consumers and providers

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `clarinet test`
5. Submit a pull request

## Roadmap

- [ ] Mobile app integration
- [ ] Advanced analytics dashboard
- [ ] Carbon footprint calculator
- [ ] Multi-chain deployment
- [ ] DAO governance implementation
- [ ] Partnership integrations with eco-brands

*Building a sustainable future, one action at a time.* 🌍