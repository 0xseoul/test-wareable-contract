// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title IItemHandler
 * @author Abe
 * @dev ItemHandler interface.
 */

interface IItemHandler {
    /**
     * @notice This struct contains data related to a Staked Tokens
     *
     */

    /// @notice event emitted when a user has burned a ERC1155 nft
    // event BurnedCloths(address owner, uint256 tokenId);
    event DressedUp(address owner, uint256 erc721Id, uint256 erc1155Id);
    event DressedDown(address owner, uint256 erc721Id, uint256 erc1155Id);

    /// @notice event emitted when a user has minted a ERC1155 nft
    // event MintedCloths(address owner, uint256 tokenId);

    function dressUp(
        uint256 _erc721Id,
        uint256 _erc1155Id,
        uint256 _type
    ) external returns (bool success);

    function dressDown(
        uint256 _erc721Id,
        uint256 _erc1155Id,
        uint256 _type
    ) external returns (bool success);

    // function dressDown(uint256 tokenId, uint256 erc1155Id)
    //     external
    //     payable
    //     returns (bool success);

    // function dressUp(uint256 tokenId, uint256 erc1155Id)
    //     external
    //     payable
    //     returns (bool success);
}
