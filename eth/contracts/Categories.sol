pragma solidity ^0.5.0;

contract Categories {

    event FileAdded(uint256 indexed id, uint indexed version, string name, string description);

    struct Subcategory {
        uint256 id;
        int256 votes;
    }

    //struct FileVersion {
    //}
    
    struct File {
        uint256 id;
        int256 votes;
        string[46][] link; // array of file versions
        uint256 eventBlock;
    }
    
    struct CategoryInfo {
        Subcategory[] subcategories;
        File[] files;
    }

    mapping (uint256 => File) private files;
    mapping (uint256 => CategoryInfo) private structure;
}
