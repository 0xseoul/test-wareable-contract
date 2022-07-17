// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title IWearable721
 * @author Abe
 * @dev Wearable721 interface.
 */

interface IWEARABLE721 {
    /**
     * @notice This struct contains data related to a Staked Tokens
     *
     * @param top - erc1155 token id of the top token
     * @param bottom - erc1155 token id of the bottom token
     */

    struct TokenInfo {
        uint256 top;
        uint256 bottom;
    }

    /// @notice event emitted when a user has burned a ERC1155 nft
    // event BurnedCloths(address owner, uint256 tokenId);

    /// @notice event emitted when a user has minted a ERC1155 nft
    // event MintedCloths(address owner, uint256 tokenId);

    function getTokenInfo(uint256 tokenId)
        external
        view
        returns (TokenInfo memory);

    function burnCloths(uint256 _type, uint256 tokenId)
        external
        returns (bool success);

    // function mintCloths(
    //     uint256 _type,
    //     uint256 tokenId,
    //     uint256 erc1155Id
    // ) external returns (bool success);
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
