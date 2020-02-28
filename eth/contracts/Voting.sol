pragma solidity ^0.5.0;

import "./BaseToken.sol";

contract Voting is BaseToken {

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'U1';

    constructor() public {
        name = "Voting";
        decimals = 8;
        symbol = "VOT";
    }

    function() payable external {
        totalSupply = msg.value;
        balances[msg.sender] += msg.value; // 1/1 exchange rate
        emit Transfer(address(this), msg.sender, msg.value);
    }
}
