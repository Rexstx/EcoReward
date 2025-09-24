;; EcoReward - Sustainability Incentive Platform with NFT Certificates
;; Version: 2.0.0
;; A platform that rewards users for eco-friendly actions and tracks environmental impact
;; Now includes NFT certificates for significant environmental milestones

;; Error constants
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-invalid-amount (err u103))
(define-constant err-insufficient-balance (err u104))
(define-constant err-invalid-action (err u105))
(define-constant err-unauthorized (err u106))
(define-constant err-action-already-claimed (err u107))
(define-constant err-invalid-verifier (err u108))
(define-constant err-milestone-not-reached (err u109))
(define-constant err-certificate-already-issued (err u110))

;; Contract owner
(define-constant contract-owner tx-sender)

;; Token name and symbol
(define-constant token-name "EcoReward Token")
(define-constant token-symbol "ECO")
(define-constant token-decimals u6)

;; NFT constants
(define-constant nft-name "EcoReward Certificate")
(define-constant nft-symbol "ECOCERT")

;; Data variables
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var total-supply uint u0)
(define-data-var next-action-id uint u1)
(define-data-var next-certificate-id uint u1)

;; Data maps
(define-map token-balances principal uint)
(define-map eco-actions 
  uint 
  {
    user: principal,
    action-type: (string-ascii 50),
    impact-score: uint,
    reward-amount: uint,
    timestamp: uint,
    verified: bool,
    verifier: (optional principal)
  }
)

(define-map action-types
  (string-ascii 50)
  {
    base-reward: uint,
    impact-multiplier: uint,
    enabled: bool
  }
)

(define-map user-stats
  principal
  {
    total-actions: uint,
    total-impact: uint,
    total-rewards: uint,
    last-action-block: uint
  }
)

(define-map verified-verifiers principal bool)

;; NFT Certificate maps
(define-map certificates
  uint
  {
    owner: principal,
    milestone-type: (string-ascii 50),
    threshold-value: uint,
    issued-at: uint,
    metadata-uri: (optional (string-utf8 256))
  }
)

(define-map milestone-thresholds
  (string-ascii 50)
  uint
)

(define-map user-certificates
  { user: principal, milestone-type: (string-ascii 50) }
  bool
)

;; Private functions
(define-private (get-balance (user principal))
  (default-to u0 (map-get? token-balances user))
)

(define-private (set-balance (user principal) (balance uint))
  (begin
    (asserts! (is-standard user) err-unauthorized)
    (map-set token-balances user balance)
    (ok true)
  )
)

(define-private (mint-tokens (recipient principal) (amount uint))
  (let ((current-balance (get-balance recipient))
        (new-balance (+ current-balance amount))
        (current-supply (var-get total-supply))
        (new-supply (+ current-supply amount)))
    (begin
      (asserts! (> amount u0) err-invalid-amount)
      (asserts! (is-standard recipient) err-unauthorized)
      (try! (set-balance recipient new-balance))
      (var-set total-supply new-supply)
      (ok true)
    )
  )
)

(define-private (is-valid-action-type (action-type (string-ascii 50)))
  (match (map-get? action-types action-type)
    action-data (get enabled action-data)
    false
  )
)

(define-private (calculate-reward (action-type (string-ascii 50)) (impact-score uint))
  (match (map-get? action-types action-type)
    action-data 
      (let ((base-reward (get base-reward action-data))
            (multiplier (get impact-multiplier action-data)))
        (* base-reward (* impact-score multiplier)))
    u0
  )
)

(define-private (check-milestone-eligibility (user principal) (milestone-type (string-ascii 50)))
  (let ((user-data (unwrap! (map-get? user-stats user) (err false)))
        (threshold (unwrap! (map-get? milestone-thresholds milestone-type) (err false))))
    (if (is-eq milestone-type "eco-warrior")
      (ok (>= (get total-actions user-data) threshold))
      (if (is-eq milestone-type "impact-champion")
        (ok (>= (get total-impact user-data) threshold))
        (if (is-eq milestone-type "green-pioneer")
          (ok (>= (get total-rewards user-data) threshold))
          (ok false)
        )
      )
    )
  )
)

(define-private (mint-certificate (recipient principal) (milestone-type (string-ascii 50)) (threshold-value uint))
  (let ((certificate-id (var-get next-certificate-id))
        (current-block stacks-block-height))
    (begin
      (map-set certificates certificate-id {
        owner: recipient,
        milestone-type: milestone-type,
        threshold-value: threshold-value,
        issued-at: current-block,
        metadata-uri: none
      })
      
      (map-set user-certificates { user: recipient, milestone-type: milestone-type } true)
      (var-set next-certificate-id (+ certificate-id u1))
      (ok certificate-id)
    )
  )
)

;; Public functions

;; Initialize default action types and milestones
(define-public (initialize-action-types)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set action-types "recycling" { base-reward: u100, impact-multiplier: u2, enabled: true })
    (map-set action-types "tree-planting" { base-reward: u500, impact-multiplier: u10, enabled: true })
    (map-set action-types "solar-energy" { base-reward: u300, impact-multiplier: u5, enabled: true })
    (map-set action-types "bike-commute" { base-reward: u50, impact-multiplier: u1, enabled: true })
    (map-set action-types "composting" { base-reward: u75, impact-multiplier: u2, enabled: true })
    
    ;; Initialize milestone thresholds
    (map-set milestone-thresholds "eco-warrior" u50)      ;; 50 actions
    (map-set milestone-thresholds "impact-champion" u1000) ;; 1000 impact points
    (map-set milestone-thresholds "green-pioneer" u10000)  ;; 10,000 tokens earned
    
    (ok true)
  )
)

;; Add or update action type
(define-public (add-action-type (action-type (string-ascii 50)) (base-reward uint) (impact-multiplier uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> base-reward u0) err-invalid-amount)
    (asserts! (> impact-multiplier u0) err-invalid-amount)
    (asserts! (> (len action-type) u0) err-invalid-action)
    (map-set action-types action-type {
      base-reward: base-reward,
      impact-multiplier: impact-multiplier,
      enabled: true
    })
    (ok true)
  )
)

;; Add milestone threshold
(define-public (add-milestone (milestone-type (string-ascii 50)) (threshold uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> threshold u0) err-invalid-amount)
    (asserts! (> (len milestone-type) u0) err-invalid-action)
    (map-set milestone-thresholds milestone-type threshold)
    (ok true)
  )
)

;; Add verified verifier
(define-public (add-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (not (is-eq verifier tx-sender)) err-unauthorized)
    (map-set verified-verifiers verifier true)
    (ok true)
  )
)

;; Submit eco action
(define-public (submit-eco-action (action-type (string-ascii 50)) (impact-score uint))
  (let ((action-id (var-get next-action-id))
        (current-block stacks-block-height))
    (begin
      (asserts! (is-valid-action-type action-type) err-invalid-action)
      (asserts! (> impact-score u0) err-invalid-amount)
      (asserts! (<= impact-score u100) err-invalid-amount)
      
      (let ((reward-amount (calculate-reward action-type impact-score)))
        (map-set eco-actions action-id {
          user: tx-sender,
          action-type: action-type,
          impact-score: impact-score,
          reward-amount: reward-amount,
          timestamp: current-block,
          verified: false,
          verifier: none
        })
        
        (var-set next-action-id (+ action-id u1))
        (ok action-id)
      )
    )
  )
)

;; Verify eco action
(define-public (verify-eco-action (action-id uint))
  (let ((action-data (unwrap! (map-get? eco-actions action-id) err-not-found)))
    (begin
      (asserts! (default-to false (map-get? verified-verifiers tx-sender)) err-unauthorized)
      (asserts! (not (get verified action-data)) err-action-already-claimed)
      
      (let ((user (get user action-data))
            (reward-amount (get reward-amount action-data))
            (impact-score (get impact-score action-data))
            (current-stats (default-to 
              { total-actions: u0, total-impact: u0, total-rewards: u0, last-action-block: u0 }
              (map-get? user-stats user))))
        
        ;; Update action as verified
        (map-set eco-actions action-id (merge action-data {
          verified: true,
          verifier: (some tx-sender)
        }))
        
        ;; Mint reward tokens
        (try! (mint-tokens user reward-amount))
        
        ;; Update user stats
        (map-set user-stats user {
          total-actions: (+ (get total-actions current-stats) u1),
          total-impact: (+ (get total-impact current-stats) impact-score),
          total-rewards: (+ (get total-rewards current-stats) reward-amount),
          last-action-block: stacks-block-height
        })
        
        (ok true)
      )
    )
  )
)

;; Claim milestone certificate
(define-public (claim-certificate (milestone-type (string-ascii 50)))
  (let ((threshold (unwrap! (map-get? milestone-thresholds milestone-type) err-not-found)))
    (begin
      (asserts! (> (len milestone-type) u0) err-invalid-action)
      (asserts! (not (default-to false (map-get? user-certificates { user: tx-sender, milestone-type: milestone-type }))) 
                err-certificate-already-issued)
      
      (let ((is-eligible (unwrap! (check-milestone-eligibility tx-sender milestone-type) err-milestone-not-reached)))
        (asserts! is-eligible err-milestone-not-reached)
        (mint-certificate tx-sender milestone-type threshold)
      )
    )
  )
)

;; Transfer tokens
(define-public (transfer (amount uint) (recipient principal))
  (let ((sender-balance (get-balance tx-sender))
        (recipient-balance (get-balance recipient))
        (new-recipient-balance (+ recipient-balance amount)))
    (begin
      (asserts! (>= sender-balance amount) err-insufficient-balance)
      (asserts! (> amount u0) err-invalid-amount)
      (asserts! (is-standard recipient) err-unauthorized)
      (asserts! (not (is-eq tx-sender recipient)) err-unauthorized)
      
      (try! (set-balance tx-sender (- sender-balance amount)))
      (try! (set-balance recipient new-recipient-balance))
      (ok true)
    )
  )
)

;; Read-only functions

;; Get token info
(define-read-only (get-token-info)
  {
    name: token-name,
    symbol: token-symbol,
    decimals: token-decimals,
    total-supply: (var-get total-supply)
  }
)

;; Get NFT info
(define-read-only (get-nft-info)
  {
    name: nft-name,
    symbol: nft-symbol,
    total-certificates: (- (var-get next-certificate-id) u1)
  }
)

;; Get balance
(define-read-only (get-balance-of (user principal))
  (ok (get-balance user))
)

;; Get eco action
(define-read-only (get-eco-action (action-id uint))
  (map-get? eco-actions action-id)
)

;; Get action type info
(define-read-only (get-action-type-info (action-type (string-ascii 50)))
  (map-get? action-types action-type)
)

;; Get user stats
(define-read-only (get-user-stats (user principal))
  (map-get? user-stats user)
)

;; Get total supply
(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

;; Check if verifier is authorized
(define-read-only (is-verifier (verifier principal))
  (default-to false (map-get? verified-verifiers verifier))
)

;; Get certificate details
(define-read-only (get-certificate (certificate-id uint))
  (map-get? certificates certificate-id)
)

;; Get milestone threshold
(define-read-only (get-milestone-threshold (milestone-type (string-ascii 50)))
  (map-get? milestone-thresholds milestone-type)
)

;; Check if user has certificate
(define-read-only (has-certificate (user principal) (milestone-type (string-ascii 50)))
  (default-to false (map-get? user-certificates { user: user, milestone-type: milestone-type }))
)

;; Check milestone eligibility
(define-read-only (check-milestone-status (user principal) (milestone-type (string-ascii 50)))
  (match (check-milestone-eligibility user milestone-type)
    eligible-result (ok eligible-result)
    error-val (ok false)
  )
)