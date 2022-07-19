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

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./interfaces/IWearable721.sol";
import "./interfaces/IWearable1155.sol";
import "./interfaces/IItemHandler.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

pragma solidity ^0.8.15;

contract ItemHandler is ReentrancyGuard, IItemHandler {
    using Strings for uint256;
    using SafeMath for uint256;
    IWEARABLE721 public wearable721;
    IWEARABLE1155 public wearable1155;

    address internal owner;

    constructor(address _erc721, address _erc1155) {
        owner = msg.sender;
        wearable721 = IWEARABLE721(_erc721);
        wearable1155 = IWEARABLE1155(_erc1155);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "0xseoul: only owner can call this function"
        );
        _;
    }

    modifier onlyAccounts() {
        require(msg.sender == tx.origin, "0xItemHandler: Not allowed origin");
        _;
    }

    function setWearable721(address _wearable721) public {
        wearable721 = IWEARABLE721(_wearable721);
    }

    function setWearable1155(address _wearable1155) public {
        wearable1155 = IWEARABLE1155(_wearable1155);
    }

    function dressUp(
        uint256 _erc721Id,
        uint256 _erc1155Id,
        uint256 _type
    ) public nonReentrant onlyAccounts returns (bool success) {
        // check _erc721Id tokwn owner
        require(
            wearable721.ownerOf(_erc721Id) == msg.sender,
            "0xseoul: you are not the owner of this erc721 token"
        );
        // check _erc1155Id tokwn owner
        require(
            wearable1155.balanceOf(msg.sender, _erc1155Id) > 0,
            "0xseoul: you are not the owner of this erc1155 token"
        );

        wearable1155.burnERC1155(_erc1155Id, msg.sender);
        wearable721.dressUp(_type, _erc721Id, _erc1155Id);
        emit DressedUp(msg.sender, _erc721Id, _erc1155Id);
        return true;
    }

    // FIXME: 이 함수 작동 안함
    function dressDown(
        uint256 _erc721Id,
        uint256 _erc1155Id,
        uint256 _type
    ) public nonReentrant returns (bool success) {
        // check _erc721Id tokwn owner
        // check _erc1155Id tokwn owner
        require(
            wearable721.ownerOf(_erc721Id) == msg.sender,
            "0xseoul: you are not the owner of this token"
        );
        // 여기 수정해야 할 듯
        // erc1155를 erc721에서 가져와서 그거를 사용해야할듯
        // type만 알려주고 getTokenInfo에서 top bottom가져와서 mint여기에 넣기
        // 그러면 _erc1155Id이거는 없애도 될듯
        wearable721.dressDown(_type, _erc721Id);
        wearable1155.mintERC1155(_erc1155Id, msg.sender);
        emit DressedDown(msg.sender, _erc721Id, _erc1155Id);
        return true;
    }
}
