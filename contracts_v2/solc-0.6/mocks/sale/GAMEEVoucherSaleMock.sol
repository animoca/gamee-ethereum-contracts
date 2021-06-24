// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

import "../../sale/GAMEEVoucherSale.sol";

/**
 * @title GAMEEVoucherSaleMock
 * A GAMEEVoucherSale contract mock implementation that handles the purchases of pre-minted
 * GAMEE token (GMEE) voucher fungible tokens from a holder account to the purchase recipient.
 */
contract GAMEEVoucherSaleMock is GAMEEVoucherSale {
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
    ) public GAMEEVoucherSale(inventory_, tokenHolder_, payoutWallet, skusCapacity, tokensPerSkuCapacity) {}

    /**
     * Calls the internal `_delivery()` purchase lifecycle function.
     * @dev Emits the DeliveryData event.
     * @param recipient The recipient of the purchase.
     * @param token The token to use as the payment currency.
     * @param sku The identifier of the SKU to purchase.
     * @param quantity The quantity to purchase.
     * @param userData Optional extra user input data.
     * @param totalPrice The amount of `token` paid.
     * @param pricingData Data set by the `_pricing()` purchase lifecycle function.
     * @param paymentData Data set by the `_payment()` puchase lifecycle function.
     */
    function underscoreDelivery(
        address payable recipient,
        address token,
        bytes32 sku,
        uint256 quantity,
        bytes calldata userData,
        uint256 totalPrice,
        bytes32[] calldata pricingData,
        bytes32[] calldata paymentData
    ) external {
        PurchaseData memory purchaseData;

        purchaseData.purchaser = _msgSender();
        purchaseData.recipient = recipient;
        purchaseData.token = token;
        purchaseData.sku = sku;
        purchaseData.quantity = quantity;
        purchaseData.userData = userData;
        purchaseData.totalPrice = totalPrice;
        purchaseData.pricingData = pricingData;
        purchaseData.paymentData = paymentData;

        _delivery(purchaseData);
    }
}
