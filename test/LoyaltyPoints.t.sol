// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {LoyaltyPoints} from "../src/LoyaltyPoints.sol";

/*
 *  This test suite documents the expected behavior of the LoyaltyPoints contract.
 *  It covers deployment, point issuance, point redemption, and the main revert paths.
 */
contract LoyaltyPointsTest is Test {
    /*
     *  The contract under test.
     */
    LoyaltyPoints private loyaltyPoints;

    /*
     *  Test actors used to simulate the issuer, a customer, and an unrelated caller.
     */
    address private issuer;
    address private customer;
    address private stranger;

    /*
     *  Deploy the contract once before each test so every case starts from a clean state.
     */
    function setUp() public {
        issuer = address(this);
        customer = address(0x1);
        stranger = address(0x2);

        loyaltyPoints = new LoyaltyPoints();
    }

    /*
     *  The deployer becomes the issuer.
     */
    function testConstructorSetsIssuer() public view {
        assertEq(loyaltyPoints.issuer(), issuer);
    }

    /*
     *  Issuance should update the target balance, total supply, and emit the expected event.
     */
    function testIssuerCanEarnPoints() public {
        vm.expectEmit(true, false, false, true);
        emit LoyaltyPoints.PointsIssued(customer, 100, "purchase");

        loyaltyPoints.earnPoints(customer, 100, "purchase");

        assertEq(loyaltyPoints.balances(customer), 100);
        assertEq(loyaltyPoints.totalSupply(), 100);
        assertEq(loyaltyPoints.totalRedeemed(), 0);
    }

    /*
     *  Only the issuer should be allowed to mint points.
     */
    function testNonIssuerCannotEarnPoints() public {
        vm.prank(stranger);
        vm.expectRevert("Only the issuer can call this function");
        loyaltyPoints.earnPoints(customer, 100, "purchase");
    }

    /*
     *  Zero-amount issuance is rejected.
     */
    function testEarnPointsRevertsOnZeroAmount() public {
        vm.expectRevert("Amount must be greater than zero");
        loyaltyPoints.earnPoints(customer, 0, "purchase");
    }

    /*
     *  Redemption should reduce the customer's balance, lower total supply, and track redeemed points.
     */
    function testRedeemPointsUpdatesBalancesAndSupply() public {
        loyaltyPoints.earnPoints(customer, 100, "purchase");

        vm.expectEmit(true, false, false, true);
        emit LoyaltyPoints.PointsRedeemed(customer, 40, "gift card");

        vm.prank(stranger);
        loyaltyPoints.redeemPoints(customer, 40, "gift card");

        assertEq(loyaltyPoints.balances(customer), 60);
        assertEq(loyaltyPoints.totalSupply(), 60);
        assertEq(loyaltyPoints.totalRedeemed(), 40);
    }

    /*
     *  Zero-amount redemption is rejected.
     */
    function testRedeemPointsRevertsOnZeroAmount() public {
        vm.expectRevert("Amount must be greater than zero");
        loyaltyPoints.redeemPoints(customer, 0, "gift card");
    }

    /*
     *  Redemption cannot exceed the customer balance.
     */
    function testRedeemPointsRevertsWhenBalanceTooLow() public {
        loyaltyPoints.earnPoints(customer, 20, "purchase");

        vm.expectRevert("Insufficient balance");
        loyaltyPoints.redeemPoints(customer, 21, "gift card");
    }

    /*
     *  Balance reads should reflect the latest stored value.
     */
    function testGetBalanceReturnsCurrentBalance() public {
        loyaltyPoints.earnPoints(customer, 77, "purchase");

        assertEq(loyaltyPoints.getBalance(customer), 77);
    }
}
