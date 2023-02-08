# Replace the following with your own values
ADDRESS="erd1qqq...xxx"
OWNER="erd1...xxx"
# Place your keystore file in the same directory as this script and replace the following with the name of the file
# Optionally, you can also put your password in the .passfile in the same directory as this script (if not, you will be prompted for the password)
PRIVATE_KEY=(--keyfile=erd1...xxx.json --passfile=.passfile)
PROXY=https://devnet-api.elrond.com
CHAIN_ID=D

# Standard deploy command. Provide any constructor arguments as needed (e.g deploy 12 TOKEN-123456). Numbers are automatically scaled to 18 decimals. (e.g. 12 -> 12000000000000000000)
deploy() {
# Arguments:
ARG_0=${1}  # 0: quorum (u32)
ARG_1=${2}  # 1: board (variadic<Address>)
    erdpy contract build
    erdpy contract deploy --bytecode output/multisig.wasm --recall-nonce ${PRIVATE_KEY} --keyfile ${OWNER}.json --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send --outfile="deploy.interaction.json" \
        --arguments ${ARG_0} ${ARG_1}

    echo "Deployed contract at the address written above."
    echo "Pleade update the ADDRESS variable in this script with the address of the deployed contract, then run 'source interaction.sh' to update the environment variables."
}

# Standard upgrade command. Provide any constructor arguments as needed (e.g upgrade 12 TOKEN-123). Numbers are automatically scaled to 18 decimals. (e.g. 12 -> 12000000000000000000)
upgrade() {
# Arguments:
ARG_0=${1}  # 0: quorum (u32)
ARG_1=${2}  # 1: board (variadic<Address>)
    erdpy contract upgrade ${ADDRESS} --bytecode output/multisig.wasm --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --arguments ${ARG_0} ${ARG_1}

}

# All contract endpoints are available as functions. Provide any arguments as needed (e.g transfer 12 TOKEN-123)

deposit() {
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "deposit"
}

sign() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "sign" \
        --arguments ${ARG_0}

}

unsign() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "unsign" \
        --arguments ${ARG_0}

}

discardAction() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "discardAction" \
        --arguments ${ARG_0}

}

proposeAddBoardMember() {
# Arguments:
ARG_0=${1}  # 0: board_member_address (Address)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeAddBoardMember" \
        --arguments ${ARG_0}

}

proposeAddProposer() {
# Arguments:
ARG_0=${1}  # 0: proposer_address (Address)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeAddProposer" \
        --arguments ${ARG_0}

}

proposeRemoveUser() {
# Arguments:
ARG_0=${1}  # 0: user_address (Address)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeRemoveUser" \
        --arguments ${ARG_0}

}

proposeChangeQuorum() {
# Arguments:
ARG_0=${1}  # 0: new_quorum (u32)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeChangeQuorum" \
        --arguments ${ARG_0}

}

proposeTransferExecute() {
# Arguments:
ARG_0=${1}  # 0: to (Address)
ARG_1=$(echo "scale=0; (${2}*10^18)/1" | bc -l)  # 1: egld_amount (BigUint)
ARG_2=${3}  # 2: opt_function (optional<bytes>)
ARG_3=${4}  # 3: arguments (variadic<bytes>)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeTransferExecute" \
        --arguments ${ARG_0} ${ARG_1} ${ARG_2} ${ARG_3}

}

proposeAsyncCall() {
# Arguments:
ARG_0=${1}  # 0: to (Address)
ARG_1=$(echo "scale=0; (${2}*10^18)/1" | bc -l)  # 1: egld_amount (BigUint)
ARG_2=${3}  # 2: opt_function (optional<bytes>)
ARG_3=${4}  # 3: arguments (variadic<bytes>)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeAsyncCall" \
        --arguments ${ARG_0} ${ARG_1} ${ARG_2} ${ARG_3}

}

proposeSCDeployFromSource() {
# Arguments:
ARG_0=$(echo "scale=0; (${1}*10^18)/1" | bc -l)  # 0: amount (BigUint)
ARG_1=${2}  # 1: source (Address)
ARG_2=${3}  # 2: code_metadata (CodeMetadata)
ARG_3=${4}  # 3: arguments (variadic<bytes>)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeSCDeployFromSource" \
        --arguments ${ARG_0} ${ARG_1} ${ARG_2} ${ARG_3}

}

proposeSCUpgradeFromSource() {
# Arguments:
ARG_0=${1}  # 0: sc_address (Address)
ARG_1=$(echo "scale=0; (${2}*10^18)/1" | bc -l)  # 1: amount (BigUint)
ARG_2=${3}  # 2: source (Address)
ARG_3=${4}  # 3: code_metadata (CodeMetadata)
ARG_4=${5}  # 4: arguments (variadic<bytes>)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "proposeSCUpgradeFromSource" \
        --arguments ${ARG_0} ${ARG_1} ${ARG_2} ${ARG_3} ${ARG_4}

}

performAction() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "performAction" \
        --arguments ${ARG_0}

}

dnsRegister() {
# Arguments:
ARG_0=${1}  # 0: dns_address (Address)
ARG_1=0x$(echo -n $2 | xxd -p -u | tr -d '\n')  # 1: name (bytes)
    erdpy contract call ${ADDRESS} \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --send \
        --function "dnsRegister" \
        --arguments ${ARG_0} ${ARG_1}

}

# All contract views. Provide arguments as needed (e.g balanceOf 0x1234567890123456789012345678901234567890)

signed() {
# Arguments:
ARG_0=${1}  # 0: user (Address)
ARG_1=${2}  # 1: action_id (u32)
    erdpy contract query ${ADDRESS} \
        --function "signed" \
        --proxy=${PROXY} \
         --arguments ${ARG_0} ${ARG_1}

}

getQuorum() {
    erdpy contract query ${ADDRESS} \
        --function "getQuorum" \
        --proxy=${PROXY}
}

getNumBoardMembers() {
    erdpy contract query ${ADDRESS} \
        --function "getNumBoardMembers" \
        --proxy=${PROXY}
}

getNumProposers() {
    erdpy contract query ${ADDRESS} \
        --function "getNumProposers" \
        --proxy=${PROXY}
}

getActionLastIndex() {
    erdpy contract query ${ADDRESS} \
        --function "getActionLastIndex" \
        --proxy=${PROXY}
}

quorumReached() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract query ${ADDRESS} \
        --function "quorumReached" \
        --proxy=${PROXY} \
         --arguments ${ARG_0}

}

getPendingActionFullInfo() {
    erdpy contract query ${ADDRESS} \
        --function "getPendingActionFullInfo" \
        --proxy=${PROXY}
}

userRole() {
# Arguments:
ARG_0=${1}  # 0: user (Address)
    erdpy contract query ${ADDRESS} \
        --function "userRole" \
        --proxy=${PROXY} \
         --arguments ${ARG_0}

}

getAllBoardMembers() {
    erdpy contract query ${ADDRESS} \
        --function "getAllBoardMembers" \
        --proxy=${PROXY}
}

getAllProposers() {
    erdpy contract query ${ADDRESS} \
        --function "getAllProposers" \
        --proxy=${PROXY}
}

getActionData() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract query ${ADDRESS} \
        --function "getActionData" \
        --proxy=${PROXY} \
         --arguments ${ARG_0}

}

getActionSigners() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract query ${ADDRESS} \
        --function "getActionSigners" \
        --proxy=${PROXY} \
         --arguments ${ARG_0}

}

getActionSignerCount() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract query ${ADDRESS} \
        --function "getActionSignerCount" \
        --proxy=${PROXY} \
         --arguments ${ARG_0}

}

getActionValidSignerCount() {
# Arguments:
ARG_0=${1}  # 0: action_id (u32)
    erdpy contract query ${ADDRESS} \
        --function "getActionValidSignerCount" \
        --proxy=${PROXY} \
         --arguments ${ARG_0}

}
