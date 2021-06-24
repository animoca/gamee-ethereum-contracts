// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

import "@animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20WithOperators.sol";

/**
 * @title GAMEE
 */
contract GAMEE is ERC20WithOperators {
    // solhint-disable-next-line const-name-snakecase
    string public constant override name = "GAMEE";
    // solhint-disable-next-line const-name-snakecase
    string public constant override symbol = "GMEE";
    // solhint-disable-next-line const-name-snakecase
    uint8 public constant override decimals = 18;

    constructor(address[] memory holders, uint256[] memory amounts) public ERC20WithOperators() {
        require(holders.length == amounts.length, "GAMEE: inconsistent arrays");
        for (uint256 i = 0; i != holders.length; ++i) {
            _mint(holders[i], amounts[i]);
        }
    }
}
