// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import "../interfaces/IERC20.sol";
import "../storage/facets/AppStorageFacet.sol";
import "../storage/facets/ERC1155StorageFacet.sol";

contract AppFacet is AppStorageFacet, ERC1155StorageFacet {
    function APP_updateMeta(
        uint256 ERC20_TokenID_,
        uint256 SR_NFT_TokenID_,
        uint256 VIP_NFT_TokenID_,
        uint256 Entropy_TokenID_,
        uint256 feeRate_,
        uint256 farmRate_,
        uint256 idx_,
        string memory baseURI_
    ) public {
        LibDiamond.enforceIsContractOwner();

        AppStorage storage _ds_app = appStorage();
        _ds_app.ERC20_TokenID = ERC20_TokenID_;
        _ds_app.SR_NFT_TokenID = SR_NFT_TokenID_;
        _ds_app.VIP_NFT_TokenID = VIP_NFT_TokenID_;
        _ds_app.Entropy_TokenID = Entropy_TokenID_;
        _ds_app.feeRate = feeRate_;
        _ds_app.farmRate = farmRate_;

        ERC1155FacetStorage storage _ds = erc1155Storage();
        _ds._idx = idx_;
        _ds._baseURI = baseURI_;
        
        _ds._tokenOwner[ERC20_TokenID_] = address(this);
        _ds._tokenOwner[SR_NFT_TokenID_] = address(this);
        _ds._tokenOwner[VIP_NFT_TokenID_] = address(this);
        _ds._tokenOwner[Entropy_TokenID_] = address(this);
    }

    function APP_getMeta()
        public
        view
        returns (
            // app metadata
            uint256 ERC20_TokenID,
            uint256 SR_NFT_TokenID,
            uint256 VIP_NFT_TokenID,
            uint256 Entropy_TokenID,
            uint256 feeRate,
            uint256 farmRate,
            // erc1155
            uint256 idx,
            string memory baseURI
        )
    {
        ERC1155FacetStorage storage _ds_erc1155 = erc1155Storage();

        AppStorage storage _ds = appStorage();
        return (
            _ds.ERC20_TokenID,
            _ds.SR_NFT_TokenID,
            _ds.VIP_NFT_TokenID,
            _ds.Entropy_TokenID,
            _ds.feeRate,
            _ds.farmRate,
            // erc1155
            _ds_erc1155._idx,
            _ds_erc1155._baseURI
        );
    }
}
