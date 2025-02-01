;; Quest system contract

(define-map quests
  uint
  {
    name: (string-ascii 24),
    reward-xp: uint,
    min-level: uint
  }
)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))

;; Create new quest
(define-public (create-quest (id uint) (name (string-ascii 24)) (reward-xp uint) (min-level uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set quests id {
      name: name,
      reward-xp: reward-xp,
      min-level: min-level
    }))))

;; Complete quest
(define-public (complete-quest (quest-id uint))
  (let (
    (quest (unwrap! (map-get? quests quest-id) (err u101)))
    (character contract-call? .character get-character))
    ;; Implementation for quest completion
    (ok true)))
