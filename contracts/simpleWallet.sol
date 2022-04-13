pragma solidity ^0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SimpleWallet is Ownable {
    mapping(address => uint) public allowance;

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    function withdraw(address payable _to, uint _amount) payable public ownerOrAllowed(_amount) {
        _to.transfer(_amount);
    }

    fallback() external payable {}

    receive() external payable {}
}