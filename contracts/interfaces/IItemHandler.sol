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
    event BurnedCloths(address owner, uint256 tokenId);

    /// @notice event emitted when a user has minted a ERC1155 nft
    event MintedCloths(address owner, uint256 tokenId);

    function burnCloths(uint256 tokenId, uint256 erc1155Id)
        external
        payable
        returns (bool success);

    function mintCloths(uint256 tokenId, uint256 erc1155Id)
        external
        payable
        returns (bool success);
}
