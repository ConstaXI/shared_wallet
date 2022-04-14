pragma solidity ^0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Onwable {
    mapping(address => uint) public allowance;

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        allowance[_who] -= _amount;
    }
}

contract SimpleWallet is Allowance {
    function withdraw(address payable _to, uint _amount) payable public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Nopt enought founds stored in this smart contract");
        
        if (!owner() == msg.sender) {
            reduceAllowance(msg.sender, _amount);
        }

        _to.transfer(_amount);
    }

    fallback() external payable {}

    receive() external payable {}
}