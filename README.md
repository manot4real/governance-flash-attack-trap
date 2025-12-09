# Governance Flash Attack Trap for Drosera Network

A simulated multivector trap detecting potential flash governance attacks using flexible threshold logic. Deployed on **Hoodi Testnet** for learning and testing.

## 📋 Overview

This trap simulates detection of flash governance attacks by monitoring 4 key vectors:
1. **New Proposal Creation** - Is there an active governance proposal?
2. **Voting Power Concentration** - Has voting power become too concentrated?
3. **Treasury Exposure** - Is a significant portion of treasury at risk?
4. **Time Criticality** - Is the voting period ending soon?

### 🔍 Flexible Threshold Logic
- **Trigger Condition**: ANY 3 of 4 conditions must be met (≥3/4)
- **Why Flexible?**: Reduces false positives while catching partial attack patterns
- **Resilience**: Tolerant to single data source failures or manipulation

## 🏗️ Technical Architecture

### Contracts
1. **GovernanceFlashAttackTrap.sol** - Implements `ITrap` interface
   - `collect()`: Reads simulated governance state
   - `shouldRespond()`: Applies flexible threshold logic (≥3/4 conditions)
   - `updateSimulatedState()`: Helper for testing on Hoodi

2. **GovernanceFlashAttackResponse.sol** - Executes when trap triggers
   - `respondToGovernanceAttack()`: Processes trigger data
   - Emits detailed events for monitoring

### Deployment Addresses (Hoodi Testnet)
- **Trap Contract**: `0x746e2965034c3912f998358C62322c66B99f9c7b` (auto-deployed by Drosera)
- **Response Contract**: `0xa1332B88f0B4FD1A883252B620F7D5f384417650`
- **Network**: Hoodi Testnet (Chain ID: 560048)

## 🎯 Monitoring Logic

### Simulated Thresholds (for Hoodi Testnet)
- **Voting Power Concentration**: >40% held by top voters
- **Treasury Exposure**: >20% of treasury at risk  
- **Time Criticality**: <24 hours until vote ends

### Example Attack Scenarios Detected
1. **Full Attack**: All 4 conditions met → CRITICAL
2. **Partial Attack**: 3 of 4 conditions met → HIGH
3. **Early Warning**: 2 of 4 conditions met → MONITOR (no trigger)

## 🔧 Testing on Hoodi Testnet

### Update Simulated State
```bash
cast send 0x746e2965034c3912f998358C62322c66B99f9c7b \
  "updateSimulatedState(uint256,uint256,uint256,uint256)" \
  1 45 25 12 --rpc-url https://rpc.hoodi.ethpandaops.io --private-key $PRIVATE_KEY
```

**Parameters :** `(proposalActive, votingPower%, treasuryExposure%, hoursRemaining)`

### Trigger Conditions
- Set at least 3 parameters above thresholds

- Wait for Drosera operator to collect and evaluate

- Check for `GovernanceAttackDetected` event on Response contract

## 📊 Drosera Configuration
`drosera.toml :` 

```[traps.governance_flash_attack_trap]
path = "out/GovernanceFlashAttackTrap.sol/GovernanceFlashAttackTrap.json"
response_contract = "0xa1332B88f0B4FD1A883252B620F7D5f384417650"
response_function = "respondToGovernanceAttack(bool,bool,bool,bool,uint8,uint256,uint256,uint256)"
cooldown_period_blocks = 33
min_number_of_operators = 1
max_number_of_operators = 3
block_sample_size = 10
private = true
whitelist = ["0xdf906B92b47007396441A77313b381C590c5Bd89"]
private_trap = true
address = "0x746e2965034c3912f998358C62322c66B99f9c7b"```

## 🚀 Mainnet Adaptation
To adapt for **Ethereum Mainnet**, replace simulated data with real contract calls:

1. **Proposal Status:** Query governance contracts (Aave, Compound, etc.)

2. **Voting Power:** Calculate from delegation/vesting contracts

3. **Treasury Exposure:** Monitor treasury balances and proposal impacts

4. **Time Data:** Use block timestamps and proposal schedules

## 📁 Project Structure
```governance-flash-attack-trap/
├── src/
│   ├── GovernanceFlashAttackTrap.sol
│   └── GovernanceFlashAttackResponse.sol
├── script/
│   └── Deploy.sol
├── lib/
│   └── drosera-contracts/
├── drosera.toml
├── foundry.toml
├── remappings.txt
└── README.md```


## 🔒 Security Considerations
- **Private Trap:** Only whitelisted addresses can trigger responses

- **Flexible Thresholds:** Requires multiple confirmations to reduce false positives

- **Cooldown Period:** 33 blocks between triggers prevents spam

- **Simulated Data:** On Hoodi, no real funds are at risk

## 📈 Value Proposition
- **Early Warning:** Detects governance attacks before execution

- **Multi-Signal:** Correlates multiple risk vectors for confidence

- **Educational:** Teaches multivector monitoring patterns

- **Production-Ready:** Pattern can be adapted for mainnet monitoring

## 👥 Author
**TheBaldKid**

## 📄 License

MIT
# governance-flash-attack-trap
