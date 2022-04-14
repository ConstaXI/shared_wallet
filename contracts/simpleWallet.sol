pragma solidity ^0.8.6;

import "./alowance.sol";

contract SimpleWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdraw(address payable _to, uint _amount) payable public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enought founds stored in this smart contract");
        
        if (!(owner() == msg.sender)) {
            reduceAllowance(msg.sender, _amount);
        }

        emit MoneySent(_to, _amount);

        _to.transfer(_amount);
    }

    function renounceOwnership() public override view onlyOwner {
        revert("Can't renounce ownership.");
    }

    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    receive() external payable {}
}