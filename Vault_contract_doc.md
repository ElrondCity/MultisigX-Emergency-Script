*This doc was auto-generated using Elrond City's Utilities Generator.*

# Vault contract documentation

Multi-signature smart contract implementation.
Acts like a wallet that needs multiple signers for any action performed.
See the readme file for more detailed documentation.
## Endpoints

### onlyOwner
- **dnsRegister**(dns_address: `Address`, name: `bytes`)

### Public
- **deposit**()
Allows the contract to receive funds even if it is marked as unpayable in the protocol.
- **sign**(action_id: `u32`)
Used by board members to sign actions.
- **unsign**(action_id: `u32`)
Board members can withdraw their signatures if they no longer desire for the action to be executed.
Actions that are left with no valid signatures can be then deleted to free up storage.
- **discardAction**(action_id: `u32`)
Clears storage pertaining to an action that is no longer supposed to be executed.
Any signatures that the action received must first be removed, via `unsign`.
Otherwise this endpoint would be prone to abuse.
- **proposeAddBoardMember**(board_member_address: `Address`) -> `u32`  
Initiates board member addition process.
Can also be used to promote a proposer to board member.
- **proposeAddProposer**(proposer_address: `Address`) -> `u32`  
Initiates proposer addition process..
Can also be used to demote a board member to proposer.
- **proposeRemoveUser**(user_address: `Address`) -> `u32`  
Removes user regardless of whether it is a board member or proposer.
- **proposeChangeQuorum**(new_quorum: `u32`) -> `u32`  
- **proposeTransferExecute**(to: `Address`, egld_amount: `BigUint`, opt_function: `optional<bytes>`, arguments: `variadic<bytes>`) -> `u32`  
Propose a transaction in which the contract will perform a transfer-execute call.
Can send EGLD without calling anything.
Can call smart contract endpoints directly.
Doesn't really work with builtin functions.
- **proposeAsyncCall**(to: `Address`, egld_amount: `BigUint`, opt_function: `optional<bytes>`, arguments: `variadic<bytes>`) -> `u32`  
Propose a transaction in which the contract will perform a transfer-execute call.
Can call smart contract endpoints directly.
Can use ESDTTransfer/ESDTNFTTransfer/MultiESDTTransfer to send tokens, while also optionally calling endpoints.
Works well with builtin functions.
Cannot simply send EGLD directly without calling anything.
- **proposeSCDeployFromSource**(amount: `BigUint`, source: `Address`, code_metadata: `CodeMetadata`, arguments: `variadic<bytes>`) -> `u32`  
- **proposeSCUpgradeFromSource**(sc_address: `Address`, amount: `BigUint`, source: `Address`, code_metadata: `CodeMetadata`, arguments: `variadic<bytes>`) -> `u32`  
- **performAction**(action_id: `u32`) -> `optional<Address>`  
Proposers and board members use this to launch signed actions.

### Readonly
- **signed**(user: `Address`, action_id: `u32`) -> `bool`  
Returns `true` (`1`) if the user has signed the action.
Does not check whether or not the user is still a board member and the signature valid.
- **getQuorum**() -> `u32`  
Minimum number of signatures needed to perform any action.
- **getNumBoardMembers**() -> `u32`  
Denormalized board member count.
It is kept in sync with the user list by the contract.
- **getNumProposers**() -> `u32`  
Denormalized proposer count.
It is kept in sync with the user list by the contract.
- **getActionLastIndex**() -> `u32`  
The index of the last proposed action.
0 means that no action was ever proposed yet.
- **quorumReached**(action_id: `u32`) -> `bool`  
Returns `true` (`1`) if `getActionValidSignerCount >= getQuorum`.
- **getPendingActionFullInfo**() -> `variadic<ActionFullInfo>`  
Iterates through all actions and retrieves those that are still pending.
Serialized full action data:
- the action id
- the serialized action data
- (number of signers followed by) list of signer addresses.
- **userRole**(user: `Address`) -> `UserRole`  
Indicates user rights.
`0` = no rights,
`1` = can propose, but not sign,
`2` = can propose and sign.
- **getAllBoardMembers**() -> `variadic<Address>`  
Lists all users that can sign actions.
- **getAllProposers**() -> `variadic<Address>`  
Lists all proposers that are not board members.
- **getActionData**(action_id: `u32`) -> `Action`  
Serialized action data of an action with index.
- **getActionSigners**(action_id: `u32`) -> `List<Address>`  
Gets addresses of all users who signed an action.
Does not check if those users are still board members or not,
so the result may contain invalid signers.
- **getActionSignerCount**(action_id: `u32`) -> `u32`  
Gets addresses of all users who signed an action and are still board members.
All these signatures are currently valid.
- **getActionValidSignerCount**(action_id: `u32`) -> `u32`  
It is possible for board members to lose their role.
They are not automatically removed from all actions when doing so,
therefore the contract needs to re-check every time when actions are performed.
This function is used to validate the signers before performing an action.
It also makes it easy to check before performing an action.