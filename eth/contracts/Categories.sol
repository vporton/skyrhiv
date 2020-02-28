pragma solidity ^0.5.0;

import './BaseToken.sol';

contract Categories is BaseToken {

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'U1';

    uint maxId = 0;
    
    event FileAdded(uint256 indexed id, uint indexed version, string title, string description);

    // voter => (issue => value)
    mapping (address => mapping (uint256 => int256)) voters;
    
    struct File {
        uint256 id;
        int256 votes;
        byte[46][] links; // array of file versions
        uint256 eventBlock;
    }
    
    struct Subcategory {
        uint256 id;
        Category category;
        int256 votes;
    }

    struct Category {
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

/// Files ///

    function createFile(uint256 _categoryId, bytes calldata _link, string calldata _title, string calldata _description) external {
        byte[46][] memory _links = new byte[46][](1);
        for (uint i=0; i<46; ++i)
            _links[0][i] = _link[i];
        File memory file = File({id: ++maxId, votes: 0, links: _links, eventBlock: block.number});
        Category storage category = categories[_categoryId].category;
        files[maxId] = file;
        category.files.push(file);
        emit FileAdded(file.id, category.files.length, _title, _description);
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
