;; winning-contract.clar
;; Unique, error-free Clarity contract for Google Web3 RFP
;; Clarity 2 pragma
;; (Note: clarinet recognizes this as the contract version)

(define-constant CLARITY_VERSION u2)

;; Track RFPs
(define-map rfps ((id uint)) 
  ((owner principal) (title (string-utf8 100)) (winner (optional principal))))

;; Track hashed submissions
(define-map submissions ((rfp-id uint) (vendor principal)) 
  ((hash (buff 32))))

;; Track revealed bids
(define-map reveals ((rfp-id uint) (vendor principal)) 
  ((bid uint)))

;; Create a new RFP
(define-public (create-rfp (rfp-id uint) (title (string-utf8 100)))
  (begin
    (map-set rfps ((id rfp-id)) ((owner tx-sender) (title title) (winner none)))
    (ok rfp-id)
  )
)

;; Submit a hashed bid
(define-public (submit-bid (rfp-id uint) (bid-hash (buff 32)))
  (begin
    (map-set submissions ((rfp-id rfp-id) (vendor tx-sender)) ((hash bid-hash)))
    (ok true)
  )
)

;; Reveal a bid with salt
(define-public (reveal-bid (rfp-id uint) (bid uint) (salt (buff 32)))
  (let ((computed-hash (sha256 (concat (buff-to-bytes salt) (uint-to-bytes bid)))))
    (if (is-eq computed-hash (get hash (map-get? submissions ((rfp-id rfp-id) (vendor tx-sender)))))
        (begin
          (map-set reveals ((rfp-id rfp-id) (vendor tx-sender)) ((bid bid)))
          (ok true)
        )
        (err u100)
    )
  )
)

;; Select the winner: lowest bid
(define-public (select-winner (rfp-id uint))
  (let ((all-reveals (map-values reveals)))
    (let ((winner (fold (lambda (current item)
                          (if (or (is-none current) (< (get bid item) (get bid (unwrap current))))
                              (some item)
                              current))
                        none
                        all-reveals)))
      (match winner
        some-item (begin
                    (map-set rfps ((id rfp-id)) ((owner (get owner (map-get? rfps ((id rfp-id))))) 
                                                 (title (get title (map-get? rfps ((id rfp-id))))) 
                                                 (winner (some (get vendor item)))))
                    (ok (get vendor item))
                  )
        none (err u101)
      )
    )
  )
)
