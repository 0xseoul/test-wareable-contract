// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title IWearable721
 * @author Abe
 * @dev Wearable721 interface.
 */

interface IWearable721 {
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

    /// @notice event emitted when a user has staked a nft
    event Staked(address owner, uint256 tokenId);

    /// @notice event emitted when a user has unstaked a nft
    event Unstaked(address owner, uint256 tokenId);

    /// @notice event emitted when a user has burned a ERC1155 nft
    event BurnedCloths(address owner, uint256 tokenId);

    /// @notice event emitted when a user has minted a ERC1155 nft
    event MintedCloths(address owner, uint256 tokenId);

    function getTokenInfo(uint256 tokenId)
        external
        view
        returns (TokenInfo memory);

    function burnCloths(uint256 tokenId, uint256 erc1155Id)
        external
        payable
        returns (bool success);

    function mintCloths(uint256 tokenId, uint256 erc1155Id)
        external
        payable
        returns (bool success);
}
