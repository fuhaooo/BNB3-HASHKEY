// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import "../storage/facets/AppStorageFacet.sol";
import "../storage/facets/ERC1155StorageFacet.sol";
import "../interfaces/IERC1155.sol";
import "../interfaces/IERC1155Receiver.sol";
import "../interfaces/IERC20.sol";
import {console} from "hardhat/console.sol";
contract TokenCreatorFacet is AppStorageFacet, ERC1155StorageFacet {
    event TokenCreator_Created(
        uint256 tokenId,
        address paymentToken,
        uint256 amount,
        string nonce
    );

    function TokenCreator_create(
        address paymentToken_,
        uint256 amount_,
        string memory nonce_,
        bytes memory signature_
    ) public {
        LibDiamond.enforceIsNotPaused();
        LibDiamond.verifySignatureAndUseNonce(
            abi.encodePacked(paymentToken_, amount_, nonce_),
            nonce_,
            signature_,
            "Invalid signature"
        );
        AppStorage storage _ds_app = appStorage();
        console.log('token', paymentToken_, _ds_app.paymentTokens[paymentToken_] == true, _ds_app.paymentTokens[paymentToken_]);

        require(
            _ds_app.paymentTokens[paymentToken_] == true,
            "Payment token does not exist"
        );
        IERC20(paymentToken_).transferFrom(msg.sender, address(this), amount_);

        ERC1155FacetStorage storage _ds = erc1155Storage();
        _ds._tokenOwner[_ds._idx++] = msg.sender;

        emit TokenCreator_Created(_ds._idx - 1, paymentToken_, amount_, nonce_);
    }
}
