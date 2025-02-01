;; Game Items - NFT implementation for game items

(define-non-fungible-token game-item uint)

;; Data Variables
(define-data-var last-item-id uint u0)

;; Item types mapping
(define-map item-types
  uint
  {
    name: (string-ascii 24),
    power: uint,
    rarity: uint
  }
)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-item-exists (err u101))

;; Create new item type
(define-public (create-item-type (name (string-ascii 24)) (power uint) (rarity uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let ((new-id (+ (var-get last-item-id) u1)))
      (map-set item-types new-id {name: name, power: power, rarity: rarity})
      (var-set last-item-id new-id)
      (ok new-id))))

;; Mint new item
(define-public (mint-item (recipient principal) (item-type uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let ((item-id (var-get last-item-id)))
      (try! (nft-mint? game-item item-id recipient))
      (ok item-id))))
