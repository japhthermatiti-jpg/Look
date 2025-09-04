# Winner
This Clarity smart contract implements a secure, fair, and efficient RFP (Request for Proposal) system for Web3. It allows multiple vendors to submit confidential bids, ensures integrity via a commitment-reveal mechanism, and automatically selects the lowest bid as the winner. Its compact and error-free design is fully compatible with Clarinet, making it ready for deployment.

Features

RFP Management

Create and track multiple RFPs with unique IDs and descriptive titles.

Store the RFP owner and winning vendor transparently on-chain.

Secure Bid Submission

Vendors submit hashed bids to keep amounts secret until the reveal phase.

Prevents early disclosure or manipulation of bids.

Bid Reveal & Verification

Vendors reveal their bids along with a salt.

The contract verifies the hash before accepting the bid.

Guarantees fairness and prevents cheating.

Automated Winner Selection

Automatically determines the lowest bid as the winner.

Fully transparent and verifiable on-chain.

Handles multiple RFPs and vendors efficiently.

Error-Free & Clarinet-Compatible

Written to pass clarinet check without errors.

Uses Clarity 2 constants and proper syntax for broad compatibility.
