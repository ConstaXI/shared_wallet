pragma solidity ^0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    mapping(address => uint) public allowance;

    event allowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit allowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit allowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
}

contract SimpleWallet is Allowance {
    function withdraw(address payable _to, uint _amount) payable public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Nopt enought founds stored in this smart contract");
        
        if (!(owner() == msg.sender)) {
            reduceAllowance(msg.sender, _amount);
        }

        _to.transfer(_amount);
    }

    fallback() external payable {}

    receive() external payable {}
}