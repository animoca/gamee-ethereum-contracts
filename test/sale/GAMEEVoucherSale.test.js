// disabled until registry dependencies are fixed for sale_base

// const {artifacts, web3} = require('hardhat');
// const {BN, ether, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
// const {stringToBytes32} = require('@animoca/ethereum-contracts-sale_base/test/utils/bytes32');
// const {ZeroAddress, EmptyByte, Zero, One, Two, Three} = require('@animoca/ethereum-contracts-core').constants;
// const {makeFungibleCollectionId} = require('@animoca/blockchain-inventory_metadata').inventoryIds;

// const Sale = artifacts.require('GAMEEVoucherSaleMock');
// const Inventory = artifacts.require('ERC1155InventoryBurnableMock.sol');
// const Erc20 = artifacts.require('ERC20Mock');

// const erc20TotalSupply = ether('1000000000');
// const purchaserErc20Balance = ether('100000');
// const erc20Price = ether('1');

// const skusCapacity = One;
// const tokensPerSkuCapacity = One;
// const sku = stringToBytes32('sku');
// const totalSupply = new BN('10');
// const maxQuantityPerPurchase = Three;
// const notificationsReceiver = ZeroAddress;
// const tokenId = makeFungibleCollectionId(1);

// const userData = EmptyByte;

// let deployer, tokenHolder, payoutWallet, purchaser, recipient, other;

// describe('GAMEEVoucherSale', function () {
//   before(async function () {
//     [deployer, tokenHolder, payoutWallet, purchaser, recipient, other] = await web3.eth.getAccounts();
//   });

//   async function doDeployErc20(overrides = {}) {
//     this.erc20 = await Erc20.new(overrides.erc20TotalSupply || erc20TotalSupply, {from: overrides.from || deployer});

//     await this.erc20.transfer(overrides.purchaser || purchaser, overrides.purchaserErc20Balance || purchaserErc20Balance, {
//       from: overrides.from || deployer,
//     });
//   }

//   async function doDeployInventory(overrides = {}) {
//     this.inventory = await Inventory.new({from: overrides.from || deployer});

//     await this.inventory.safeMint(
//       overrides.tokenHolder || tokenHolder,
//       overrides.tokenId || tokenId,
//       overrides.quantity || totalSupply,
//       overrides.userData || userData,
//       {from: overrides.from || deployer}
//     );
//   }

//   async function doDeploySale(overrides = {}) {
//     this.sale = await Sale.new(
//       overrides.inventory || this.inventory.address,
//       overrides.tokenHolder || tokenHolder,
//       overrides.payoutWallet || payoutWallet,
//       overrides.skusCapacity || skusCapacity,
//       overrides.tokensPerSkuCapacity || tokensPerSkuCapacity,
//       {from: overrides.from || deployer}
//     );
//   }

//   async function doCreateSku(overrides = {}) {
//     await this.sale.createSku(
//       overrides.sku || sku,
//       overrides.totalSupply || totalSupply,
//       overrides.maxQuantityPerPurchase || maxQuantityPerPurchase,
//       overrides.notificationReceiver || notificationsReceiver,
//       overrides.tokenId || tokenId,
//       {from: overrides.from || deployer}
//     );
//   }

//   async function doUpdateSkuPricing(overrides = {}) {
//     await this.sale.updateSkuPricing(overrides.sku || sku, [overrides.erc20Address || this.erc20.address], [overrides.erc20Price || erc20Price], {
//       from: overrides.from || deployer,
//     });
//   }

//   async function doSetApprovalForAll(overrides = {}) {
//     await this.inventory.setApprovalForAll(overrides.operator || this.sale.address, overrides.approved || true, {
//       from: overrides.from || tokenHolder,
//     });
//   }

//   describe('constructor', function () {
//     beforeEach(async function () {
//       await doDeployInventory.bind(this)();
//     });

//     describe('when `inventory_` is the zero address', function () {
//       it('reverts', async function () {
//         await expectRevert(doDeploySale.bind(this)({inventory: ZeroAddress}), 'GAMEEVoucherSale: zero address inventory');
//       });
//     });

//     describe('when `tokeHolder_` is the zero address', function () {
//       it('reverts', async function () {
//         await expectRevert(doDeploySale.bind(this)({tokenHolder: ZeroAddress}), 'GAMEEVoucherSale: zero address token holder');
//       });
//     });

//     describe('when successful', function () {
//       beforeEach(async function () {
//         await doDeploySale.bind(this)();
//       });

//       it('sets the inventory contract correctly', async function () {
//         const inventory = await this.sale.inventory();
//         inventory.should.be.equal(this.inventory.address);
//       });

//       it('sets the token holder correctly', async function () {
//         const holder = await this.sale.tokenHolder();
//         holder.should.be.equal(tokenHolder);
//       });
//     });
//   });

//   describe('createSku()', function () {
//     beforeEach(async function () {
//       await doDeployInventory.bind(this)();
//       await doDeploySale.bind(this)();
//     });

//     describe('when the token ID is the zero address', function () {
//       it('reverts', async function () {
//         await expectRevert(doCreateSku.bind(this)({tokenId: Zero}), 'GAMEEVoucherSale: zero token ID');
//       });
//     });

//     describe('when successful', function () {
//       beforeEach(async function () {
//         await doCreateSku.bind(this)();
//       });

//       it('sets the sku token ID correctly', async function () {
//         const skuTokenId = await this.sale.skuTokenIds(sku);
//         skuTokenId.should.be.bignumber.equal(new BN(tokenId));
//       });
//     });
//   });

//   describe('_delivery()', function () {
//     beforeEach(async function () {
//       await doDeployErc20.bind(this)();
//       await doDeployInventory.bind(this)();
//       await doDeploySale.bind(this)();
//       await doCreateSku.bind(this)();
//       await doUpdateSkuPricing.bind(this)();
//       await doSetApprovalForAll.bind(this)();
//     });

//     describe('when successful', function () {
//       const quantity = Two;

//       beforeEach(async function () {
//         this.tokenHolderBalance = await this.inventory.balanceOf(tokenHolder, tokenId);
//         this.recipientBalance = await this.inventory.balanceOf(recipient, tokenId);
// this.receipt = await this.sale.underscoreDelivery(
//   recipient,
//   this.erc20.address,
//   sku,
//   quantity,
//   userData,
//   quantity.mul(erc20Price),
//   [],
//   [],
//   {from: purchaser}
// );
//       });

//       it('delivers the purchased goods correctly', async function () {
//         const tokenHolderBalance = await this.inventory.balanceOf(tokenHolder, tokenId);
//         const recipientBalance = await this.inventory.balanceOf(recipient, tokenId);
//         tokenHolderBalance.should.be.bignumber.equal(this.tokenHolderBalance.sub(quantity));
//         recipientBalance.should.be.bignumber.equal(this.recipientBalance.add(quantity));
//       });

//       it('emits the TransferSingle event', async function () {
//         expectEvent.inTransaction(this.receipt.tx, this.inventory, 'TransferSingle', {
//           _operator: this.sale.address,
//           _from: tokenHolder,
//           _to: recipient,
//           _id: tokenId,
//           _value: quantity,
//         });
//       });
//     });
//   });
// });
