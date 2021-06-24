// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import "@animoca/ethereum-contracts-assets_inventory-8.0.0/contracts/token/ERC1155/ERC1155InventoryBurnable.sol";
import "@animoca/ethereum-contracts-assets_inventory-8.0.0/contracts/token/ERC1155/IERC1155InventoryMintable.sol";
import "@animoca/ethereum-contracts-assets_inventory-8.0.0/contracts/token/ERC1155/IERC1155InventoryCreator.sol";
import "@animoca/ethereum-contracts-assets_inventory-8.0.0/contracts/metadata/BaseMetadataURI.sol";
import "@animoca/ethereum-contracts-core_library-5.0.0/contracts/access/MinterRole.sol";

contract GameeVouchersV2 is ERC1155InventoryBurnable, IERC1155InventoryMintable, IERC1155InventoryCreator, BaseMetadataURI, MinterRole {
    // solhint-disable-next-line const-name-snakecase
    string public constant name = "GameeVouchers";
    // solhint-disable-next-line const-name-snakecase
    string public constant symbol = "GameeVouchers";

    // ===================================================================================================
    //                                 User Public Functions
    // ===================================================================================================

    //================================== ERC1155MetadataURI =======================================/

    /// @dev See {IERC1155MetadataURI-uri(uint256)}.
    function uri(uint256 id) external view virtual override returns (string memory) {
        return _uri(id);
    }

    //================================== ERC1155InventoryCreator =======================================/

    /// @dev See {IERC1155InventoryCreator-creator(uint256)}.
    function creator(uint256 collectionId) external view override returns (address) {
        return _creator(collectionId);
    }

    // ===================================================================================================
    //                               Admin Public Functions
    // ===================================================================================================

    /**
     * Creates a collection.
     * @dev Reverts if `collectionId` does not represent a collection.
     * @dev Reverts if `collectionId` has already been created.
     * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
     * @param collectionId Identifier of the collection.
     */
    function createCollection(uint256 collectionId) external onlyOwner {
        require(collectionId.isFungibleToken(), "GameeVouchers: only fungibles");
        _createCollection(collectionId);
    }

    //================================== ERC1155InventoryMintable =======================================/

    /**
     * Safely mints some token.
     * @dev See {IERC1155InventoryMintable-safeMint(address,uint256,uint256,bytes)}.
     */
    function safeMint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override {
        require(isMinter(_msgSender()), "Inventory: not a minter");
        require(id.isFungibleToken(), "GameeVouchers: only fungibles");
        _safeMint(to, id, value, data);
    }

    /**
     * Safely mints a batch of tokens.
     * @dev See {IERC1155721InventoryMintable-safeBatchMint(address,uint256[],uint256[],bytes)}.
     */
    function safeBatchMint(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override {
        require(isMinter(_msgSender()), "Inventory: not a minter");
        for (uint256 i; i != ids.length; ++i) {
            require(ids[i].isFungibleToken(), "GameeVouchers: only fungibles");
        }
        _safeBatchMint(to, ids, values, data);
    }
}
