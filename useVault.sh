# Fill in the variables in interaction.sh and run the script
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
echo "8 - Display contract info"
echo "9 - Display proposal info"

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

    proposeTransferExecuteEsdt $ADDRESS 0 "ESDTTransfer" $TOKEN $AMOUNT
}

option3() {
    echo "Exercise caution when changing the quorum. Changing it to a value higher than the number of board members will lock the contract."
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

#TODO: keep going

option6() {
    echo "Querying the blockchain..."
    echo "$bold Quorum: $normal"
    getQuorum
    echo "$bold Transactions: $normal"
    getTransactions
}

option7() {
    echo "Proposal ID:"
    read ID

    echo "Querying the blockchain..."
    echo "$bold Proposal type: $normal"
    proposalType $ID
    echo "$bold Proposal destination (use erdpy to decode address): $normal"
    proposalDestination $ID
    echo "$bold Proposal value: $normal"
    proposalValue $ID
    echo "$bold Proposal token: $normal"
    proposalToken $ID



}

case $INPUT in
"1") option1 ;;
"2") option2 ;;
"3") option3 ;;
"4") option4 ;;
"5") option5 ;;
"6") option6 ;;
"7") option7 ;;
*) echo "Not a valid option" ;;
esac
