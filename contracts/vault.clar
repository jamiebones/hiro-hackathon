   (use-trait sip10-token .ptoken.sip-010-trait)

   (define-constant less-than-zero-error (err u200))


   (define-map balances principal uint )
   (define-data-var totalSupply uint u0)

    (define-private (mint (to principal) (shares uint)) 
      (begin 
        (
            let (
                  ( prevTotalSupply (var-get totalSupply))
                )
            (var-set totalSupply (+ prevTotalSupply shares))
           
        )
          (match (map-get? balances to ) prevBalance
                (map-set balances to (+ prevBalance shares))
                   (map-set balances to shares)
                   
            )
        (print "shares minted")
      )
    )


    (define-private (burn (from principal) (shares uint)) 
        (begin 
           (
                let (
                    (prevTotalSupply (var-get totalSupply))
                )
                 (var-set totalSupply (- prevTotalSupply shares))
             )

                (match (map-get? balances from ) prevBalance
                 (map-set balances from (- prevBalance shares))
                 false ;;why did this work?
                   
            )
           (print "shares minted")
           
        )
    )



    ;;    function deposit(uint256 _amount) external {
    ;;     /*
    ;;     a = amount
    ;;     B = balance of token before deposit
    ;;     T = total supply
    ;;     s = shares to mint

    ;;     (T + s) / T = (a + B) / B 

    ;;     s = aT / B
    ;;     */
    ;;     uint256 shares;
    ;;     if (totalSupply == 0) {
    ;;         shares = _amount;
    ;;     } else {
    ;;         shares = (_amount * totalSupply) / token.balanceOf(address(this));
    ;;     }

    ;;     _mint(msg.sender, shares);
    ;;     token.transferFrom(msg.sender, address(this), _amount);
    ;; }

    ;;#[allow(unchecked_data)]
    (define-public (deposit (amount uint) (token <sip10-token>)) 
        (begin 
          (asserts! (> amount u0) less-than-zero-error)
               (if (is-eq (var-get totalSupply) u0) 
                   (mint tx-sender amount)
                 (begin 
                   (
                     let (
                        (balance (try! (contract-call? token get-balance (as-contract tx-sender))))
                        (shares (/ (* amount (var-get totalSupply)) balance))
                     )
                     (mint tx-sender shares)
                   )
                 )
        
            )
            
          (contract-call? token transfer amount tx-sender (as-contract tx-sender) none)
        
        )
    )