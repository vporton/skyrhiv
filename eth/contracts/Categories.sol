pragma solidity ^0.5.0;

import './BaseToken.sol';

contract Categories is BaseToken {

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'U1';

    uint maxId = 0;
    
    event FileAdded(uint256 indexed id, uint indexed version, string name, string description);

    struct Subcategory {
        Category category;
        int256 votes;
    }

    // voter => (issue => value)
    mapping (address => mapping (uint256 => int256)) voters;
    
    struct File {
        uint256 id;
        int256 votes;
        string[46][] link; // array of file versions
        uint256 eventBlock;
    }
    
    struct Category {
        uint256 id;
        uint256[] subcategories;
        File[] files;
    }

    mapping (uint256 => File) private files;
    mapping (uint256 => Subcategory) private categories;

/// ERC-20 ///

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

/// Voting ///

    function voteForFile(uint256 _issue, bool _yes) external {
        int256 _value = _yes ? int256(balances[msg.sender]) : -int256(balances[msg.sender]);
        files[_issue].votes += -voters[msg.sender][_issue] + _value; // reclaim the previous vote
        voters[msg.sender][_issue] = _value;
    }

    function voteForCategory(uint256 _issue, bool _yes) external {
        int256 _value = _yes ? int256(balances[msg.sender]) : -int256(balances[msg.sender]);
        categories[_issue].votes += -voters[msg.sender][_issue] + _value; // reclaim the previous vote
        voters[msg.sender][_issue] = _value;
    }
}
