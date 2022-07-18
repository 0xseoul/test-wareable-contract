// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/**
 * @title IWearable1155
 * @author Abe
 * @dev Wearable1155 interface.
 */

interface IWEARABLE1155 is IERC1155 {
    /**
     * @notice This struct contains data related to a Staked Tokens
     *
     */

    function mintERC1155(uint256 erc1155Id, address _to)
        external
        returns (bool success);

    function burnERC1155(uint256 erc1155Id, address _to)
        external
        returns (bool success);

    /// @notice event emitted when a user has burned a ERC1155 nft
    event BurnedCloths(address owner, uint256 tokenId);
    /// @notice event emitted when a user has minted a ERC1155 nft
    event MintedCloths(address owner, uint256 tokenId);
}
