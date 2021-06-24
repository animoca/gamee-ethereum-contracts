// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

import "@animoca/ethereum-contracts-sale_base-8.0.0/contracts/sale/FixedPricesSale.sol";

/**
 * @title GAMEEVoucherSale
 * A FixedPricesSale contract implementation that handles the purchase of pre-minted GAMEE token
 * (GMEE) voucher fungible tokens from a holder account to the purchase recipient.
 */
contract GAMEEVoucherSale is FixedPricesSale {
    IGAMEEVoucherInventoryTransferable public immutable inventory;

    address public immutable tokenHolder;

    mapping(bytes32 => uint256) public skuTokenIds;

    /**
     * Constructor.
     * @dev Reverts if `inventory_` is the zero address.
     * @dev Reverts if `tokenHolder_` is the zero address.
     * @dev Emits the `MagicValues` event.
     * @dev Emits the `Paused` event.
     * @param inventory_ The inventory contract from which the sale supply is attributed from.
     * @param tokenHolder_ The account holding the pool of sale supply tokens.
     * @param payoutWallet the payout wallet.
     * @param skusCapacity the cap for the number of managed SKUs.
     * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
     */
    constructor(
        address inventory_,
        address tokenHolder_,
        address payoutWallet,
        uint256 skusCapacity,
        uint256 tokensPerSkuCapacity
    ) public FixedPricesSale(payoutWallet, skusCapacity, tokensPerSkuCapacity) {
        // solhint-disable-next-line reason-string
        require(inventory_ != address(0), "GAMEEVoucherSale: zero address inventory");
        // solhint-disable-next-line reason-string
        require(tokenHolder_ != address(0), "GAMEEVoucherSale: zero address token holder");
        inventory = IGAMEEVoucherInventoryTransferable(inventory_);
        tokenHolder = tokenHolder_;
    }

    /**
     * Creates an SKU.
     * @dev Reverts if `totalSupply` is zero.
     * @dev Reverts if `sku` already exists.
     * @dev Reverts if `notificationsReceiver` is not the zero address and is not a contract address.
     * @dev Reverts if the update results in too many SKUs.
     * @dev Reverts if `tokenId` is zero.
     * @dev Emits the `SkuCreation` event.
     * @param sku The SKU identifier.
     * @param totalSupply The initial total supply.
     * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
     * @param notificationsReceiver The purchase notifications receiver contract address.
     *  If set to the zero address, the notification is not enabled.
     * @param tokenId The inventory contract token ID to associate with the SKU, used for purchase
     *  delivery.
     */
    function createSku(
        bytes32 sku,
        uint256 totalSupply,
        uint256 maxQuantityPerPurchase,
        address notificationsReceiver,
        uint256 tokenId
    ) external onlyOwner whenPaused {
        require(tokenId != 0, "GAMEEVoucherSale: zero token ID");
        _createSku(sku, totalSupply, maxQuantityPerPurchase, notificationsReceiver);
        skuTokenIds[sku] = tokenId;
    }

    /**
     * Lifecycle step which delivers the purchased SKUs to the recipient.
     * @dev Responsibilities:
     *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
     *  - Handle any internal logic related to the delivery, including the remaining supply update;
     *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
     * @dev Reverts if there is not enough available supply.
     * @dev If this function is overriden, the implementer SHOULD super call it.
     * @param purchase The purchase conditions.
     */
    function _delivery(PurchaseData memory purchase) internal override {
        super._delivery(purchase);
        inventory.safeTransferFrom(tokenHolder, purchase.recipient, skuTokenIds[purchase.sku], purchase.quantity, "");
    }
}

/**
 * @dev Interface for the transfer function of the GAMEE voucher inventory contract.
 */
interface IGAMEEVoucherInventoryTransferable {
    /**
     * Safely transfers some token.
     * @dev Reverts if `to` is the zero address.
     * @dev Reverts if the sender is not approved.
     * @dev Reverts if `from` has an insufficient balance.
     * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
     * @dev Emits a `TransferSingle` event.
     * @param from Current token owner.
     * @param to Address of the new token owner.
     * @param id Identifier of the token to transfer.
     * @param value Amount of token to transfer.
     * @param data Optional data to send along to a receiver contract.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;
}
