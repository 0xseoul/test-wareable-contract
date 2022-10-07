/**
                                                             __ 
                                                            /  |
  ______   __    __   _______   ______    ______   __    __ $$ |
 /      \ /  \  /  | /       | /      \  /      \ /  |  /  |$$ |
/$$$$$$  |$$  \/$$/ /$$$$$$$/ /$$$$$$  |/$$$$$$  |$$ |  $$ |$$ |
$$ |  $$ | $$  $$<  $$      \ $$    $$ |$$ |  $$ |$$ |  $$ |$$ |
$$ \__$$ | /$$$$  \  $$$$$$  |$$$$$$$$/ $$ \__$$ |$$ \__$$ |$$ |
$$    $$/ /$$/ $$  |/     $$/ $$       |$$    $$/ $$    $$/ $$ |
 $$$$$$/  $$/   $$/ $$$$$$$/   $$$$$$$/  $$$$$$/   $$$$$$/  $$/ 
                                                                                                                                                                                                                                  
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// extensions/ERC1155Supply.sol
// https://gateway.pinata.cloud/ipfs/QmYpqAu6DBvuiWM3M8Tz5aqjA94HQaxw52qKhX6XmHzxMp/metadata-item1.json
// https://gateway.pinata.cloud/ipfs/QmYpqAu6DBvuiWM3M8Tz5aqjA94HQaxw52qKhX6XmHzxMp/metadata-item2.json

contract WEARABLE1155 is ERC1155Supply, Ownable, ReentrancyGuard {
    string public name;
    string public symbol;
    /**
       1 => hat
       2 => top
       3 => bottom
       4 => shoes
       ...
     */
    //     token id => token type
    mapping(uint256 => uint256) public clothesTypes;

    address internal itemHandler;

    address internal admin;
    uint256 public totalSupply;

    mapping(uint256 => string) public tokenURI;

    constructor() ERC1155(" ") {
        name = "EDEN";
        symbol = "0xSEOUL";
    }

    // 이거 바꾸기
    modifier onlyItemHandler() {
        require(
            msg.sender == itemHandler || msg.sender == owner(),
            "0xWEARABLE1155:you're not the item handler"
        );
        _;
    }

    modifier onlyAdmin() {
        require(
            msg.sender == owner() || msg.sender == admin,
            "0xWEARABLE1155:you're not the admin"
        );
        _;
    }

    function uri(uint256 _id) public view override returns (string memory) {
        require(exists(_id), "ERC1155 token does not exist");
        return tokenURI[_id];
    }

    function setURI(uint256 _id, string memory _uri) public onlyOwner {
        tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }

    function setItemHandler(address _itemHandler) public onlyOwner {
        itemHandler = _itemHandler;
    }

    function setAdmin(address _admin) external onlyOwner {
        admin = _admin;
    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) external onlyOwner nonReentrant {
        _mintBatch(_to, _ids, _amounts, "");
    }

    function mint(address _to, uint256 _id)
        external
        onlyItemHandler
        nonReentrant
    {
        require(exists(_id), "ERC1155 token does not exist");
        _mint(_to, _id, 1, "");
    }

    function mintERC1155(uint256 erc1155Id, address _to)
        public
        nonReentrant
        onlyItemHandler
        returns (bool success)
    {
        require(exists(erc1155Id), "ERC1155 token does not exist");
        _mint(_to, erc1155Id, 1, "");
        return true;
    }

    function burn(uint256 _id, uint256 _amount)
        external
        onlyItemHandler
        nonReentrant
    {
        require(
            balanceOf(msg.sender, _id) > _amount + 1,
            "0xSEOUL: balance is not enough"
        );
        _burn(msg.sender, _id, _amount);
    }

    function burnERC1155(uint256 erc1155Id, address _to)
        public
        returns (bool success)
    {
        require(
            balanceOf(_to, erc1155Id) > 0,
            "0xSEOUL: balance is not enough"
        );
        _burn(_to, erc1155Id, 1);
        return true;
    }

    function burnBatch(uint256[] memory _ids, uint256[] memory _amounts)
        external
        onlyItemHandler
        nonReentrant
    {
        for (uint256 i = 0; i < _ids.length; i++) {
            require(
                balanceOf(msg.sender, _ids[i]) > _amounts[i] + 1,
                "0xSEOUL: balance is not enough"
            );
        }
        _burnBatch(msg.sender, _ids, _amounts);
    }

    function createNewClothes(
        uint256 _type,
        uint256 _tokenSupply,
        string memory _uri
    ) external onlyAdmin {
        uint256 _tokenId = totalSupply + 1;
        _mint(owner(), _tokenId, _tokenSupply, "");
        setURI(_tokenId, _uri);
        clothesTypes[_tokenId] = _type;
        totalSupply = totalSupply + 1;
    }
}
