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
            "0xseoul itemHandler: only owner can call this function"
        );
        _;
    }

    modifier onlyAccounts() {
        require(
            msg.sender == tx.origin,
            "0xseoul itemHandler: Not allowed origin"
        );
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
            "0xseoul itemHandler: you are not the owner of this erc721 token"
        );
        // check _erc1155Id tokwn owner
        require(
            wearable1155.balanceOf(msg.sender, _erc1155Id) > 0,
            "0xseoul itemHandler: you are not the owner of this erc1155 token"
        );
        uint256 _wearingERC1155Id = getWearingERC1155Id(_type, _erc721Id);

        if (_wearingERC1155Id != 0)
            revert("0xseoul itemHandler: you are already wearing this item");

        wearable1155.burnERC1155(_erc1155Id, msg.sender);
        wearable721.dressUp(_type, _erc721Id, _erc1155Id);
        emit DressedUp(msg.sender, _erc721Id, _erc1155Id);
        return true;
    }

    // FIXME: 이 함수 작동 안함
    function dressDown(uint256 _erc721Id, uint256 _type)
        public
        nonReentrant
        returns (bool success)
    {
        // check _erc721Id tokwn owner
        // check _erc1155Id tokwn owner
        require(
            wearable721.ownerOf(_erc721Id) == msg.sender,
            "0xseoul itemHandler: you are not the owner of ERC721 token"
        );

        uint256 _erc1155Id = getWearingERC1155Id(_type, _erc721Id);
        if (_erc1155Id == 0)
            revert("0xseoul itemHandler: this token is not dressed");

        // 여기 수정해야 할 듯
        // erc1155를 erc721에서 가져와서 그거를 사용해야할듯
        // type만 알려주고 getTokenInfo에서 top bottom가져와서 mint여기에 넣기
        // 그러면 _erc1155Id이거는 없애도 될듯
        wearable721.dressDown(_type, _erc721Id);
        wearable1155.mintERC1155(_erc1155Id, msg.sender);
        emit DressedDown(msg.sender, _erc721Id, _erc1155Id);
        return true;
    }

    function getWearingERC1155Id(uint256 _type, uint256 _erc721Id)
        public
        view
        returns (uint256)
    {
        IWEARABLE721.TokenInfo memory _tokenInfo = wearable721.getTokenInfo(
            _erc721Id
        );

        uint256[18] memory _erc1155Ids = [
            _tokenInfo.hair,
            _tokenInfo.clothing,
            _tokenInfo.eyes,
            _tokenInfo.mouth,
            _tokenInfo.offHand,
            _tokenInfo.eyeWear,
            _tokenInfo.skin,
            _tokenInfo.background,
            _tokenInfo.additionalItem1,
            _tokenInfo.additionalItem2,
            _tokenInfo.additionalItem3,
            _tokenInfo.additionalItem4,
            _tokenInfo.additionalItem5,
            _tokenInfo.additionalItem6,
            _tokenInfo.additionalItem7,
            _tokenInfo.additionalItem8,
            _tokenInfo.additionalItem9,
            _tokenInfo.additionalItem10
        ];
        uint256 _erc1155Id = _erc1155Ids[_type];
        return _erc1155Id;
    }
}
