// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title IWearable721
 * @author Abe
 * @dev Wearable721 interface.
 */
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IWEARABLE721 is IERC721 {
    /**
     * @notice This struct contains data related to Tokens
     *
     * @param hair - erc1155 token id of the hair token
     * @param background - erc1155 token id of the background token
     * @param additionalItem -  erc1155 token id which will be used in future updates

     */

    struct TokenInfo {
        uint256 hair; // 0
        uint256 clothing; // 1
        uint256 eyes; // 2
        uint256 mouth; // 3
        uint256 offHand; // 4
        uint256 eyeWear; // 5
        uint256 skin; // 6
        uint256 background; // 7
        uint256 additionalItem1; // 8
        uint256 additionalItem2; // 9
        uint256 additionalItem3; // 10
        uint256 additionalItem4; // 11
        uint256 additionalItem5; // 12
        uint256 additionalItem6; // 13
        uint256 additionalItem7; // 14
        uint256 additionalItem8; // 15
        uint256 additionalItem9; // 16
        uint256 additionalItem10; // 17
    }

    enum TokenInfoEnum {
        hair,
        clothing,
        eyes,
        mouth,
        offHand,
        eyeWear,
        skin,
        background,
        additionalItem1,
        additionalItem2,
        additionalItem3,
        additionalItem4,
        additionalItem5,
        additionalItem6,
        additionalItem7,
        additionalItem8,
        additionalItem9,
        additionalItem10
    }

    /// @notice event emitted when a user has burned a ERC1155 nft
    // event BurnedCloths(address owner, uint256 tokenId);

    /// @notice event emitted when a user has minted a ERC1155 nft
    // event MintedCloths(address owner, uint256 tokenId);

    function getTokenInfo(uint256 erc721Id)
        external
        view
        returns (TokenInfo memory);

    function dressDown(uint256 _type, uint256 erc721Id)
        external
        returns (bool success);

    function dressUp(
        uint256 _type,
        uint256 erc721Id,
        uint256 erc1155Id
    ) external returns (bool success);
}

// staking 쪽으로 가는게 아마도 비용측면에서 나을듯
// 민팅비용이 많이 나오니까 transfer비용보다
// 그럼 클레임을 누가 걸수있는거야?
// 그 erc721소유주만
// 근데 staking을 하면 그게 되나?
// 만약에 옷을 입힌 상태로 판매하면?
// 그러면 소유주가 바뀌는데?
// 그러면 staking에 정보는 그대로잖아
// 보안측면에서 많이 떨어지지?
// 그럼 오너 address를 넣는거는 의미가 없겠네?
// ERC721에서 ownerOf를 안에 넣어야겠네
