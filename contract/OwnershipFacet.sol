// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import { IERC173 } from "../interfaces/IERC173.sol";

contract OwnershipFacet is IERC173 {
    function setPaused(bool isPaused_) external {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.setPaused(isPaused_);
    }

    function isPaused() external view returns (bool) {
        return LibDiamond.isPaused();
    }

    function transferOwnership(address _newOwner) external override {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.setContractOwner(_newOwner);
    }

    function owner() external override view returns (address) {
        return LibDiamond.contractOwner();
    }

    function getSigner() external view returns (address) {
        return LibDiamond.getSigner();
    }

    function updateSigner(address signer) external {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.updateSigner(signer);
    }
}
