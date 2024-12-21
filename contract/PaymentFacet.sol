// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import "../interfaces/IERC20.sol";
import "../storage/facets/AppStorageFacet.sol";
import "../storage/facets/ERC1155StorageFacet.sol";

contract PaymentFacet is AppStorageFacet, ERC1155StorageFacet {
    function Payment_getPaymentTokenStatus(
        address token_
    ) public view returns (bool) {
        AppStorage storage _ds = appStorage();
        return _ds.paymentTokens[token_];
    }

    event Event_Payment_updatePaymentTokenStatus(address token_, bool status_);

    function Payment_updatePaymentTokenStatus(
        address token_,
        bool status_
    ) public {
        LibDiamond.enforceIsContractOwner();
        AppStorage storage _ds = appStorage();
        _ds.paymentTokens[token_] = status_;
        emit Event_Payment_updatePaymentTokenStatus(token_, status_);
    }

    function Payment_userVaultBalance(
        address paymentToken_,
        address user_
    ) public view returns (uint256) {
        AppStorage storage _ds = appStorage();
        return _ds.userVaultMap[user_][paymentToken_];
    }

    event Event_Payment_userVaultWithdraw(
        address user_,
        address paymentToken_,
        uint256 amount_
    );

    function Payment_userVaultWithdraw(
        address paymentToken_,
        uint256 amount_
    ) public {
        LibDiamond.enforceIsNotPaused();
        AppStorage storage _ds = appStorage();
        require(
            _ds.userVaultMap[msg.sender][paymentToken_] >= amount_,
            "Insufficient balance"
        );
        _ds.userVaultMap[msg.sender][paymentToken_] -= amount_;
        IERC20(paymentToken_).transfer(msg.sender, amount_);
        emit Event_Payment_userVaultWithdraw(
            msg.sender,
            paymentToken_,
            amount_
        );
    }

    function Payment_tokenVaultBalance(
        address paymentToken_,
        uint256 tokenID_
    ) public view returns (uint256, uint256) {
        AppStorage storage _ds = appStorage();
        return (
            _ds.lockedTokenVaultMap[tokenID_][paymentToken_],
            _ds.unlockedTokenVaultMap[tokenID_][paymentToken_]
        );
    }

    event Event_Payment_tokenVaultWithdraw(
        address user_,
        uint256 tokenID_,
        address paymentToken_,
        uint256 amount_
    );

    function Payment_tokenVaultWithdraw(
        address paymentToken_,
        uint256 tokenID_,
        uint256 amount_
    ) public {
        LibDiamond.enforceIsNotPaused();
        ERC1155FacetStorage storage _ds_erc1155 = erc1155Storage();
        require(
            _ds_erc1155._tokenOwner[tokenID_] == msg.sender,
            "Only token owner can withdraw"
        );

        AppStorage storage _ds = appStorage();
        require(
            _ds.unlockedTokenVaultMap[tokenID_][paymentToken_] >= amount_,
            "Insufficient token vault balance"
        );
        _ds.unlockedTokenVaultMap[tokenID_][paymentToken_] -= amount_;
        IERC20(paymentToken_).transfer(msg.sender, amount_);
        emit Event_Payment_tokenVaultWithdraw(
            msg.sender,
            tokenID_,
            paymentToken_,
            amount_
        );
    }

    function Payment_platformProfit(
        address paymentToken_
    ) public view returns (uint256) {
        AppStorage storage _ds = appStorage();
        return _ds.platformProfitMap[paymentToken_];
    }

    event Event_Payment_adminVaultWithdraw(
        address user_,
        address paymentToken_,
        uint256 amount_
    );

    function Payment_adminVaultWithdraw(
        address paymentToken_,
        uint256 amount_
    ) public {
        LibDiamond.enforceIsContractOwner();
        IERC20(paymentToken_).transfer(msg.sender, amount_);
        emit Event_Payment_adminVaultWithdraw(
            msg.sender,
            paymentToken_,
            amount_
        );
    }
}
