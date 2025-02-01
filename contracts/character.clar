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

;; Create character
(define-public (create-character (name (string-ascii 24)))
  (begin
    (asserts! (is-none (map-get? characters tx-sender)) err-character-exists)
    (ok (map-set characters tx-sender {
      name: name,
      level: u1,
      experience: u0
    }))))

;; Level up character
(define-public (add-experience (amount uint))
  (let ((current-char (unwrap! (map-get? characters tx-sender) err-no-character)))
    (ok (map-set characters tx-sender
      (merge current-char {experience: (+ (get experience current-char) amount)})))))
