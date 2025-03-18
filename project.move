module MyModule::NFTMembership {
    use std::string::String;
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    
    // Error codes
    const ENOT_AUTHORIZED: u64 = 1;
    const EMEMBERSHIP_ALREADY_EXISTS: u64 = 2;
    const EMEMBERSHIP_EXPIRED: u64 = 3;
    
    // Struct representing a single membership
    struct Membership has key, store {
        id: u64,
        name: String,
        expiration: u64,  // Timestamp when membership expires
        is_active: bool
    }
    
    // Registry to track all issued memberships
    struct MembershipRegistry has key {
        membership_count: u64
    }
    
    // Initialize the membership service
    public entry fun initialize(admin: &signer) {
        let admin_addr = signer::address_of(admin);
        assert!(!exists<MembershipRegistry>(admin_addr), EMEMBERSHIP_ALREADY_EXISTS);
        
        // Create and store the registry
        move_to(admin, MembershipRegistry {
            membership_count: 0
        });
    }
    
    // Issue a new membership NFT to a user
    public entry fun issue_membership(
        admin: &signer, 
        recipient: address,
        name: String,
        validity_days: u64
    ) acquires MembershipRegistry {
        let admin_addr = signer::address_of(admin);
        
        // Make sure admin has the registry
        assert!(exists<MembershipRegistry>(admin_addr), ENOT_AUTHORIZED);
        
        // Get current registry
        let registry = borrow_global_mut<MembershipRegistry>(admin_addr);
        
        // Generate new membership ID
        let membership_id = registry.membership_count + 1;
        
        // Calculate expiration (assume timestamp is in seconds)
        let expiration = timestamp::now_seconds() + (validity_days * 86400); // days to seconds
        
        // Create membership resource and store it at recipient's address
        let membership = Membership {
            id: membership_id,
            name,
            expiration,
            is_active: true
        };
        
        // Store the membership to admin (in a real implementation, we'd need a way to transfer to recipient)
        move_to(admin, membership);
        
        // Update the registry
        registry.membership_count = membership_id;
    }
    
    // Check if a membership is valid
    public fun is_valid_membership(owner: address, id: u64): bool acquires Membership {
        if (!exists<Membership>(owner)) {
            return false
        };
        
        let membership = borrow_global<Membership>(owner);
        if (membership.id != id) {
            return false
        };
        
        if (!membership.is_active) {
            return false
        };
        
        // Check if expired
        let current_time = timestamp::now_seconds();
        if (current_time > membership.expiration) {
            return false
        };
        
        true
    }
}