# NFT-Based Membership Smart Contract

A simple Move smart contract for managing NFT-based memberships on the Aptos blockchain.

## Overview

This project implements a straightforward membership system using Move language on Aptos. The smart contract allows an admin to issue membership NFTs with configurable validity periods. Each membership has a unique identifier, name, expiration timestamp, and active status.

## Features

- **Initialize Membership Registry**: Set up a membership service with a counter for tracking issued memberships
- **Issue Memberships**: Create and assign memberships with customizable names and validity periods
- **Membership Validation**: Check if a membership is valid and not expired

## Contract Structure

### Resources

1. **Membership**
   - `id`: Unique identifier for each membership
   - `name`: Name/title of the membership
   - `expiration`: Timestamp when the membership expires
   - `is_active`: Boolean indicating if the membership is active

2. **MembershipRegistry**
   - `membership_count`: Counter tracking the total number of memberships issued

### Functions

1. **initialize**
   - Initializes the membership service for an admin
   - Creates a new MembershipRegistry resource

2. **issue_membership**
   - Issues a new membership with a specified name and validity period
   - Increments the membership counter
   - Stores the membership resource

3. **is_valid_membership**
   - Verifies if a membership exists, is active, and has not expired
   - Returns a boolean indicating validity

## How to Use

### Setup

1. Clone this repository to your local machine
2. Make sure you have the Aptos CLI installed
3. Compile the smart contract:
   ```bash
   aptos move compile
   ```

### Deployment

Deploy the contract to the Aptos blockchain:

```bash
aptos move publish
```

### Interacting with the Contract

1. **Initialize the Membership Registry**:
   ```bash
   aptos move run --function-id <address>::NFTMembership::initialize
   ```

2. **Issue a New Membership**:
   ```bash
   aptos move run --function-id <address>::NFTMembership::issue_membership \
     --args address:<recipient_address> string:<membership_name> u64:<validity_days>
   ```

3. **Check Membership Validity** (via view function):
   ```bash
   aptos move view --function-id <address>::NFTMembership::is_valid_membership \
     --args address:<owner_address> u64:<membership_id>
   ```

## Development Notes

- In a real-world implementation, you would want to add functionality to transfer memberships between accounts
- The current implementation stores memberships at the admin's address; a production version would need to handle resource placement properly
- Additional features like membership revocation or renewal could be implemented

## Error Codes

- `ENOT_AUTHORIZED (1)`: Operation attempted by an unauthorized account
- `EMEMBERSHIP_ALREADY_EXISTS (2)`: Attempt to create a duplicate registry
- `EMEMBERSHIP_EXPIRED (3)`: The membership has passed its expiration date

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
"transaction_hash": "0xed72102cdc11173e93832c458c42e59391739a6d56ab9d2c64f6f64e55e98db7",
