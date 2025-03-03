;; Character management contract

;; Constants
(define-constant MAX-LEVEL u100)
(define-constant MIN-NAME-LENGTH u1)
(define-constant err-character-exists (err u100))
(define-constant err-no-character (err u101))
(define-constant err-invalid-name (err u102))
(define-constant exp-per-level u100)

;; Data maps
(define-map characters
  principal
  {
    name: (string-ascii 24),
    level: uint,
    experience: uint
  }
)

;; Helper functions
(define-private (is-valid-name (name (string-ascii 24)))
  (>= (len name) MIN-NAME-LENGTH))

(define-private (has-character (who principal))
  (is-some (map-get? characters who)))

;; Calculate level from experience with cap
(define-private (calculate-level (exp uint))
  (min MAX-LEVEL (+ u1 (/ exp exp-per-level))))

;; Create character
(define-public (create-character (name (string-ascii 24)))
  (begin
    (asserts! (is-valid-name name) err-invalid-name)
    (asserts! (not (has-character tx-sender)) err-character-exists)
    (ok (map-set characters tx-sender {
      name: name,
      level: u1,
      experience: u0
    }))))

;; Get character data
(define-public (get-character)
  (ok (unwrap! (map-get? characters tx-sender) err-no-character)))

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
