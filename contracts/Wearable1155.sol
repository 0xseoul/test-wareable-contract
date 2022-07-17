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

    uint256 public constant GOLD = 1;
    uint256 public constant SILVER = 2;
    // uint256 public constant THORS_HAMMER = 2;
    // uint256 public constant SWORD = 3;
    // uint256 public constant SHIELD = 4;
    mapping(uint256 => string) public tokenURI;

    constructor() ERC1155(" ") {
        // constructor(string memory uri_) ERC1155(uri_) {
        // "https://game.example/api/item/{id}.json"
        name = "0xLAWAREABLE";
        symbol = "0xLA";
        // setURI(GOLD, uri_);

        _mint(msg.sender, GOLD, 10, "");
        _mint(msg.sender, SILVER, 20, "");

        setURI(
            GOLD,
            "ipfs://QmYpqAu6DBvuiWM3M8Tz5aqjA94HQaxw52qKhX6XmHzxMp/metadata-item1.json"
        );

        setURI(
            SILVER,
            "ipfs://QmYpqAu6DBvuiWM3M8Tz5aqjA94HQaxw52qKhX6XmHzxMp/metadata-item2.json"
        );
        // _mint(msg.sender, GOLD, 10**18, "");
        // _mint(msg.sender, SILVER, 10**27, "");
        // _mint(msg.sender, THORS_HAMMER, 1, "");
        // _mint(msg.sender, SWORD, 10**9, "");
        // _mint(msg.sender, SHIELD, 10**9, "");
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return tokenURI[_id];
    }

    // function setTokenURI(uint256 _id, string memory _uri) public {
    //     tokenURI[_id] = _uri;
    // }

    function setURI(uint256 _id, string memory _uri) public onlyOwner {
        tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) external onlyOwner {
        _mintBatch(_to, _ids, _amounts, "");
    }

    function burn(uint256 _id, uint256 _amount) external {
        require(
            balanceOf(msg.sender, _id) > _amount + 1,
            "0xSEOUL: balance is not enough"
        );
        _burn(msg.sender, _id, _amount);
    }

    function burnBatch(uint256[] memory _ids, uint256[] memory _amounts)
        external
    {
        for (uint256 i = 0; i < _ids.length; i++) {
            require(
                balanceOf(msg.sender, _ids[i]) > _amounts[i] + 1,
                "0xSEOUL: balance is not enough"
            );
        }
        _burnBatch(msg.sender, _ids, _amounts);
    }
}
