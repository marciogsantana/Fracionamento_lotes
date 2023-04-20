// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FractionalNFT is ERC1155, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    uint256 private fraction;

    /*
     * @dev mapping to record the authorized accounts to be AA
     */
    mapping(address => bool) private minters_authorized;
    /*
     * @dev mapping to record the authorized accounts of the popular
     */
    mapping(address => bool) private popular_authorized;

    /*
     * @dev mapping to record account owners
     */

    mapping(uint256 => address) private _tokenOwners;

    /*
     * @dev mapping to track transfers of token parts
     */

    mapping(uint256 => address[]) private _trackOwners;

    /*
     * @dev mapping for transferring assets to heirs
     */

    mapping(address => address) private _patrimony;

    /*
     * @dev mapping to check if an account is an heir
     */
    mapping(address => bool) private _account_patrimony;

    constructor() ERC1155("") {}

    /**
     * @dev events
     */

    event Minted(address indexed owner, uint256 tokenId);

    event Fractionalize(
        uint256 indexed tokenId,
        address indexed owner,
        uint256 fraction
    );

    event FractionTransferred(
        uint256 indexed tokenId,
        address indexed from,
        address indexed to,
        uint256 amount
    );

    event FractionalTransfer(
        uint256 indexed tokenId,
        address indexed from,
        address indexed to,
        uint256 amount
    );

    /**
     * @dev Modifier only AA accounts in mapping
     */

    modifier onlyAuthorized() {
        require(
            minters_authorized[msg.sender],
            "Only authorized minters can mint new NFTs"
        );
        _;
    }

    /**
       @dev Inheritance account only modifier
     * 
     */
    modifier patrimonyAuthorized() {
        require(_account_patrimony[msg.sender], "Only authorized heritares");
        _;
    }

    /**
     * @dev Popular accounts only modifier in mapping
     */
    modifier popularAuthorized() {
        require(popular_authorized[msg.sender], "Only authorized pupulares");
        _;
    }

    /**
     * @dev Popular accounts only modifier in mapping
     * @param _minter, authorized account
     */
    function addMInterAuthorized(address _minter) public onlyOwner {
        minters_authorized[_minter] = true;
    }

    /**
     * @dev Remove AA authorized accounts in mapping
     * @param _minter, unauthorized account
     */

    function removeMinterAuthorized(address _minter) public onlyOwner {
        minters_authorized[_minter] = false;
    }

    /**
     * @dev Mint the NFT only if it's AA
     * @ tokenID gets current account value
     * @ tokenID 1 defined that the NFT is unique
     * @ tokenID and incremented
     */

    function mint() public onlyAuthorized returns (uint256) {
        uint256 tokenId = _tokenIdTracker.current();
        _mint(msg.sender, tokenId, 1, "");
        _tokenOwners[tokenId] = msg.sender;
        _tokenIdTracker.increment();
        emit Minted(msg.sender, tokenId);
        return tokenId;
    }

    /**
     * @dev Checks if the account has an NFT and Fractions it into parts, this fractionation maintains a relationship
     * @dev with your original NFT example I divide 10 so we have 1 NFT divided into 10 parts
     * @ param token id
     * @ param number of parts to split the NFT
     */

    function fractionalize(uint256 tokenId, uint256 _fraction)
        public
        onlyAuthorized
    {
        require(
            _fraction > 0,
            "FractionalNFT: Amount should be greater than zero"
        );
        require(
            balanceOf(msg.sender, tokenId) == 1,
            "FractionalNFT: Only the AA can fractionalize the token"
        );
        _mint(msg.sender, tokenId, _fraction, "");
        fraction = _fraction;
        emit Fractionalize(tokenId, msg.sender, _fraction);
    }

    /**
     * @dev makes the transfer of NFT fractions
     * @ param id token token
     * @ param recipient address
     * @ param number of parts of the NFT
     */

    function transferFraction(
        uint256 tokenId,
        address to,
        uint256 amount
    ) public onlyAuthorized {
        require(to != address(0), "FractionalNFT: transfer to zero address");
        require(
            amount > 0,
            "FractionalNFT: Amount should be greater than zero"
        );
        require(
            balanceOf(msg.sender, tokenId) >= amount,
            "FractionalNFT: Not enough balance to transfer"
        );
        popular_authorized[to] = true; // update popular mapping
        _trackOwners[tokenId].push(msg.sender); // update mapping mapping
        safeTransferFrom(msg.sender, to, tokenId, amount, "");
        emit FractionTransferred(tokenId, msg.sender, to, amount);
    }

    /**
     * @dev makes the transfer of NFT fractions of popular to AA account or to another popular
     * @ param id token token
     * @ param recipient address
     * @ param number of parts of the NFT
     */

    function transferFraction_populares(
        uint256 tokenId,
        address to,
        uint256 amount
    ) public popularAuthorized {
        require(to != address(0), "FractionalNFT: transfer to zero address");
        require(
            amount > 0,
            "FractionalNFT: Amount should be greater than zero"
        );
        require(
            balanceOf(msg.sender, tokenId) >= amount,
            "FractionalNFT: Not enough balance to transfer"
        );
        safeTransferFrom(msg.sender, to, tokenId, amount, "");
        _trackOwners[tokenId].push(msg.sender); // update mapping mapping
        emit FractionalTransfer(tokenId, msg.sender, to, amount);
    }

    /**
     * @dev makes the transfer in full NFT to the account if it has all parts of the NFT
     * @dev this NFT can be fractionated again if the account that is calling does not have all the parts
     * @dev the transaction fails
     * @ param tokenID
     * @
     */

    function transferFullNFT(uint256 tokenId) public {
        uint256[] memory ids = new uint256[](fraction);
        uint256[] memory amounts = new uint256[](fraction);

        for (uint256 i = 0; i < fraction; i++) {
            ids[i] = tokenId;
            amounts[i] = 1;
            require(
                balanceOf(msg.sender, tokenId) >= 1,
                "FractionalNFT: Sender does not own all fractions"
            );
            _burn(msg.sender, tokenId, 1);
        }

        _mint(msg.sender, tokenId, 1, "");
    }

    /**
     * @dev returns all fraction source addresses of NFT token tracking
     * @ param Id token token
     */

    function getTrackOwners(uint256 tokenId)
        public
        view
        returns (address[] memory)
    {
        return _trackOwners[tokenId];
    }

    /**
     * @dev maps the owner wallet to the wallet that receives the inheritance
     * @ only active owner with balance can register heir
       @ the account owner, when registering the account, must use the setApprovalForAll
       @ function to authorize the address that will receive the inheritance
       @ param Address that will receive the inheritance
    */
        
    function addrPatrimony(address _heritage) public popularAuthorized {
        require(
            _heritage != address(0),
            "FractionalNFT: transfer to zero address"
        );
        _patrimony[msg.sender] = _heritage;
        _account_patrimony[_heritage] = true; // update modifier for inheritance
    }
    
    /**
     * @dev this transfer function can only be called by the wallet that is registered as an heir
       @dev the wallet that will call the function needs to be registered in the addrPatrimony function and in the setApprovalForAll function (native of ERC-1155)
     * @ only the wallet authorized to receive the inheritance can call the function
       @ the account owner, when registering the account, must use the setApprovalForAll
       @ param Asset owner address
       @ param token id
       @ param balance
    */

    function transferPatrimony(
        address _owner,
        uint256 tokenId,
        uint256 amount
    ) public patrimonyAuthorized {
        require(
            amount > 0,
            "FractionalNFT: Amount should be greater than zero"
        );
        require(
            _owner != address(0),
            "FractionalNFT: transfer to zero address"
        );
        if (_patrimony[_owner] == msg.sender) {
            require(
                balanceOf(_owner, tokenId) >= amount,
                "FractionalNFT: Not enough balance to transfer"
            );
            safeTransferFrom(_owner, msg.sender, tokenId, amount, "");
        }
    }
}
