;; Character management contract

(define-map characters
  principal
  {
    name: (string-ascii 24),
    level: uint,
    experience: uint
  }
)

;; Error constants
(define-constant err-character-exists (err u100))
(define-constant err-no-character (err u101))

;; Experience thresholds
(define-constant exp-per-level u100)

;; Create character
(define-public (create-character (name (string-ascii 24)))
  (begin
    (asserts! (is-none (map-get? characters tx-sender)) err-character-exists)
    (ok (map-set characters tx-sender {
      name: name,
      level: u1,
      experience: u0
    }))))

;; Get character data
(define-public (get-character)
  (ok (unwrap! (map-get? characters tx-sender) err-no-character)))

;; Calculate level from experience
(define-private (calculate-level (exp uint))
  (+ u1 (/ exp exp-per-level)))

;; Add experience and handle level up
(define-public (add-experience (amount uint))
  (let (
    (current-char (unwrap! (map-get? characters tx-sender) err-no-character))
    (new-exp (+ (get experience current-char) amount))
    (new-level (calculate-level new-exp))
  )
    (ok (map-set characters tx-sender
      (merge current-char {
        experience: new-exp,
        level: new-level
      })))))
