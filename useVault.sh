!#/bin/bash

# Fill in the variables in interaction.sh and run this script
bold=$(tput bold)
normal=$(tput sgr0)

source ./interaction.sh

echo "$bold - MultisigX's Vault interaction scipt - $normal"

if [ $ADDRESS = "erd1qqq...xxx" ]; then
    echo "Please update interaction.sh lines 2, 3 and 6"
    echo "with your Vault address and your address."
    exit 1
fi

echo "Vault address: $bold $ADDRESS $normal"
echo "What do you want to do?"
echo "1 - Propose eGld transfer"
echo "2 - Propose ESDT transfer"
echo "3 - Propose quorum change"
echo "4 - Propose adding a board member"
echo "5 - Propose adding a proposer"
echo "6 - Sign proposal"
echo "7 - Unsign proposal"
echo "8 - Execute proposal"
echo "9 - Discard proposal"
echo "10 - Display contract info"
echo "11 - Display proposal info"

read INPUT

option1() {
    echo "Recipient address:"
    read RECIPIENT
    echo "Amount to transfer (1 = 1eGld. Input floating point numbers as 0.01):"
    read AMOUNT

    proposeTransferExecute $RECIPIENT $AMOUNT
}

option2() {
    echo "Recipient address:"
    read RECIPIENT
    echo "Token id:"
    read TOKEN
    echo "Amount to transfer (1 = 1ECITY. Input floating numbers as 0.01):"
    read AMOUNT

    TOKEN=$(echo -n $TOKEN | xxd -p -u | tr -d '\n')
    AMOUNT=$(echo "scale=0; (${AMOUNT}*10^18)/1" | bc -l)
    AMOUNT=$(printf "%016x" $AMOUNT)
    ESDTT="ESDTTransfer"
    ESDTT=$(echo -n $ESDTT | xxd -p -u | tr -d '\n')

    BECH32RECIPIENT=$(erdpy wallet bech32 --decode $RECIPIENT)
    DATA="proposeAsyncCall@${BECH32RECIPIENT}@@${ESDTT}@${TOKEN}@${AMOUNT}"
    
    erdpy tx new --receiver $ADDRESS --data $DATA \
        --recall-nonce ${PRIVATE_KEY} --gas-limit=500000000 --proxy=${PROXY} --chain=${CHAIN_ID} --value 0 --send
}

option3() {
    echo "Exercise caution when changing the quorum. Changing it to a value higher than the number of board members with access to their keys will lock the contract."
    echo "New quorum:"
    read QUORUM

    proposeChangeQuorum $QUORUM
}

option4() {
    echo "New member's address:"
    read MEMBER

    proposeAddBoardMember $MEMBER
}

option5() {
    echo "New proposer's address:"
    read PROPOSER

    proposeAddProposer $PROPOSER
}

option6() {
    echo "Proposal ID:"
    read ID

    sign $ID
}

option7() {
    echo "Proposal ID:"
    read ID

    unsign $ID
}

option8() {
    echo "Proposal ID:"
    read ID

    performAction $ID
}

option9() {
    echo "Proposal ID:"
    read ID

    NB_SIGNERS=$(getActionValidSignerCount $ID)
    NB_SIGNERS=$(echo "$NB_SIGNERS" | jq '.[0].number')

    if [ $NB_SIGNERS -gt 0 ]; then
        echo "This proposal has already been signed by $NB_SIGNERS board member(s). All signatures need to be removed before discarding the proposal."
        exit 1
    fi

    discardAction $ID
}

option10() {
    echo "Querying the blockchain..."

    echo "$bold Quorum: $normal"
    QUORUM=$(getQuorum)
    QUORUM_NUMBER=$(echo "$QUORUM" | jq '.[0].number')
    echo "$QUORUM_NUMBER"

    echo "$bold Last action's ID: $normal"
    ID=$(getActionLastIndex)
    ID_NUMBER=$(echo "$ID" | jq '.[0].number')
    echo "$ID_NUMBER"

    #echo "$bold Pending action full info: $normal"
    #getPendingActionFullInfo

    echo "$bold All Board members: $normal"
    BOARD_MEMBERS=$(getAllBoardMembers)
    HEX_VALUES=($(echo "$BOARD_MEMBERS" | jq -r '.[].hex'))
    for hex_value in "${HEX_VALUES[@]}"; do
        erdpy wallet bech32 --encode "$hex_value"
    done
}

# TODO

option11() {
    echo "Proposal ID:"
    read ID

    echo "Querying the blockchain..."
    
    echo "$bold Quorum: $normal"
    QUORUM=$(getQuorum)
    QUORUM_NUMBER=$(echo "$QUORUM" | jq '.[0].number')
    echo "$QUORUM_NUMBER"

    echo "$bold How many signers? $normal"
    NB_SIGNERS=$(getActionValidSignerCount $ID)
    NB_SIGNERS=$(echo "$NB_SIGNERS" | jq '.[0].number')
    echo "$NB_SIGNERS"
}

case $INPUT in
"1") option1 ;;
"2") option2 ;;
"3") option3 ;;
"4") option4 ;;
"5") option5 ;;
"6") option6 ;;
"7") option7 ;;
"8") option8 ;;
"9") option9 ;;
"10") option10 ;;
"11") option11 ;;
*) echo "Not a valid option" ;;
esac
