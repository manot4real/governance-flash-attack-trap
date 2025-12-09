// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovernanceFlashAttackResponse.sol";

/**
 * @title DeployScript
 * @dev Deploys ONLY the Response contract to the target network.
 * IMPORTANT: Drosera Network automatically deploys the Trap contract via `drosera apply`
 * DO NOT deploy the Trap contract manually.
 */
contract DeployScript is Script {
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();
        
        // Deploy ONLY the Response contract
        GovernanceFlashAttackResponse response = new GovernanceFlashAttackResponse();
        
        // Log the deployed address
        console.log("==========================================");
        console.log("GovernanceFlashAttackResponse deployed at:");
        console.logAddress(address(response));
        console.log("==========================================");
        console.log("IMPORTANT: Do NOT deploy the Trap contract.");
        console.log("Drosera will auto-deploy it via 'drosera apply'");
        console.log("==========================================");
        
        // Stop broadcasting
        vm.stopBroadcast();
    }
}
