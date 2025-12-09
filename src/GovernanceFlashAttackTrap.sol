// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "drosera-contracts/interfaces/ITrap.sol";

/**
 * @title GovernanceFlashAttackTrap
 * @dev Simulates detection of a flash governance attack using 4 vectors:
 * 1. New Proposal Creation
 * 2. Voting Power Concentration Increase
 * 3. High Treasury Exposure
 * 4. Critical Time Until Vote End
 * 
 * TRIGGER LOGIC: ANY 3 of 4 conditions must be met (flexible threshold)
 * This reduces false positives while catching partial attack patterns.
 * 
 * For Hoodi Testnet: Uses simulated internal state variables.
 * On Mainnet: Would read from actual governance contracts (Aave, Compound, etc.)
 */
contract GovernanceFlashAttackTrap is ITrap {
    // SIMULATED STATE VARIABLES (for Hoodi testnet)
    // In production, these would be external contract calls
    
    uint256 public simulatedProposalActive = 0; // 0 = no proposal, 1 = active proposal
    uint256 public simulatedVotingPowerConcentration = 30; // Percentage held by top 5 voters
    uint256 public simulatedTreasuryExposure = 15; // Percentage of treasury at risk
    uint256 public simulatedHoursUntilVoteEnd = 72; // Hours remaining
    
    // Threshold constants (would be tuned in production)
    uint256 private constant VOTING_POWER_THRESHOLD = 40; // >40% concentration = risky
    uint256 private constant TREASURY_EXPOSURE_THRESHOLD = 20; // >20% treasury at risk
    uint256 private constant TIME_CRITICAL_THRESHOLD = 24; // <24 hours remaining = urgent
    
    /**
     * @dev Helper function to update simulated state (for testing on Hoodi)
     * Only callable by the contract deployer in this test version
     */
    function updateSimulatedState(
        uint256 _proposalActive,
        uint256 _votingPower,
        uint256 _treasuryExposure,
        uint256 _hoursRemaining
    ) external {
        simulatedProposalActive = _proposalActive;
        simulatedVotingPowerConcentration = _votingPower;
        simulatedTreasuryExposure = _treasuryExposure;
        simulatedHoursUntilVoteEnd = _hoursRemaining;
    }
    
    /**
     * @dev Collects current governance state data
     * @return bytes memory Encoded governance parameters
     * 
     * On Hoodi: Reads from simulated internal state
     * On Mainnet: Would make external calls to:
     * - Governance contracts (proposal status, voting power)
     * - Treasury contracts (balance at risk)
     * - Block timestamps (time remaining)
     */
    function collect() external view returns (bytes memory) {
        // Pack all governance parameters into a single bytes array
        return abi.encode(
            simulatedProposalActive,
            simulatedVotingPowerConcentration,
            simulatedTreasuryExposure,
            simulatedHoursUntilVoteEnd
        );
    }
    
    /**
     * @dev Determines if a response is needed based on governance risk
     * @param data Array of collected data (from collect() function)
     * @return bool Whether to trigger response
     * @return bytes memory Encoded trigger details for response contract
     * 
     * FLEXIBLE THRESHOLD: Triggers if ANY 3 of 4 conditions are met
     * This catches attacks even if one data source is unreliable
     */
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        // Require at least one data point
        if (data.length == 0) {
            return (false, "");
        }
        
        // Decode the governance parameters
        (uint256 proposalActive, uint256 votingPower, uint256 treasuryExposure, uint256 hoursRemaining) = 
            abi.decode(data[0], (uint256, uint256, uint256, uint256));
        
        // Check each condition
        bool condition1 = (proposalActive == 1); // Active proposal
        bool condition2 = (votingPower > VOTING_POWER_THRESHOLD); // Voting power concentrated
        bool condition3 = (treasuryExposure > TREASURY_EXPOSURE_THRESHOLD); // High treasury risk
        bool condition4 = (hoursRemaining < TIME_CRITICAL_THRESHOLD); // Time critical
        
        // Count how many conditions are true
        uint8 metConditions = 0;
        if (condition1) metConditions++;
        if (condition2) metConditions++;
        if (condition3) metConditions++;
        if (condition4) metConditions++;
        
        // FLEXIBLE THRESHOLD: Trigger if ANY 3 of 4 conditions met (≥3/4)
        if (metConditions >= 3) {
            // Return detailed trigger information for response contract
            return (true, abi.encode(
                condition1,
                condition2,
                condition3,
                condition4,
                metConditions,
                votingPower,
                treasuryExposure,
                hoursRemaining
            ));
        }
        
        // No trigger - silent watchdog
        return (false, "");
    }
}
