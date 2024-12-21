// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {console} from "hardhat/console.sol";

import {LibDiamond} from "../libraries/LibDiamond.sol";
import "../storage/facets/AppStorageFacet.sol";
import "../storage/facets/ERC1155StorageFacet.sol";
import "../interfaces/IERC1155.sol";
import "../interfaces/IERC1155Receiver.sol";
import "../interfaces/IERC20.sol";

contract ERC1155Facet is AppStorageFacet, ERC1155StorageFacet, IERC1155 {
    // ========== application funcs start ==========
    event PaymentReceived(
        address paymentToken,
        uint256 paymentAmount,
        address sender,
        uint256 tokenId,
        uint256 tokenAmount
    );

    function mintFT(
        address to_,
        uint256 tokenId_,
        uint256 amount_,
        address paymentToken_,
        uint256 paymentAmount_,
        string memory nonce_,
        bytes memory signature_
    ) public {
        AppStorage storage _ds_app = appStorage();
        bool isFT = tokenId_ == _ds_app.ERC20_TokenID ||
            tokenId_ == _ds_app.Entropy_TokenID;
        require(isFT, "Invalid token id");

        LibDiamond.enforceIsNotPaused();
        LibDiamond.verifySignatureAndUseNonce(
            abi.encodePacked(
                to_,
                tokenId_,
                amount_,
                paymentToken_,
                paymentAmount_,
                nonce_
            ),
            nonce_,
            signature_,
            "Invalid signature"
        );
        if (paymentToken_ != address(0)) {
            require(
                _ds_app.paymentTokens[paymentToken_] == true,
                "Payment token does not in whitelist"
            );
            IERC20(paymentToken_).transferFrom(
                msg.sender,
                address(this),
                paymentAmount_
            );
            _ds_app.platformProfitMap[paymentToken_] += paymentAmount_;
            emit PaymentReceived(
                paymentToken_,
                paymentAmount_,
                msg.sender,
                tokenId_,
                amount_
            );
        }

        _mint(to_, tokenId_, amount_, "");
    }

    function mintNFT(
        address to_,
        uint256 tokenId_,
        uint256 amount_,
        address paymentToken_,
        uint256 paymentAmount_,
        string memory nonce_,
        bytes memory signature_
    ) public {
        AppStorage storage _ds_app = appStorage();
        bool isNFT = tokenId_ == _ds_app.SR_NFT_TokenID ||
            tokenId_ == _ds_app.VIP_NFT_TokenID;
        require(isNFT, "Invalid token id");

        LibDiamond.enforceIsNotPaused();
        LibDiamond.verifySignatureAndUseNonce(
            abi.encodePacked(
                to_,
                tokenId_,
                amount_,
                paymentToken_,
                paymentAmount_,
                nonce_
            ),
            nonce_,
            signature_,
            "Invalid signature"
        );
        if (paymentToken_ != address(0)) {
            require(
                _ds_app.paymentTokens[paymentToken_] == true,
                "Payment token does not in whitelist"
            );
            IERC20(paymentToken_).transferFrom(
                msg.sender,
                address(this),
                paymentAmount_
            );
            _ds_app.platformProfitMap[paymentToken_] += paymentAmount_;
            emit PaymentReceived(
                paymentToken_,
                paymentAmount_,
                msg.sender,
                tokenId_,
                amount_
            );
        }

        _mint(to_, tokenId_, amount_, "");
    }

    event MintCreatorToken(
        address sender,
        uint256 tokenId,
        uint256 tokenAmount,
        address paymentToken,
        uint256 paymentAmount,
        string nonce
    );

    function mintCreatorToken(
        uint256 tokenId_,
        uint256 tokenAmount_,
        address paymentToken_,
        uint256 paymentAmount_,
        string memory nonce_,
        bytes memory signature_
    ) public {
        LibDiamond.enforceIsNotPaused();
        LibDiamond.verifySignatureAndUseNonce(
            abi.encodePacked(
                tokenId_,
                tokenAmount_,
                paymentToken_,
                paymentAmount_,
                nonce_
            ),
            nonce_,
            signature_,
            "Invalid signature"
        );

        if (paymentToken_ != address(0)) {
            AppStorage storage _ds_app = appStorage();
            require(
                _ds_app.paymentTokens[paymentToken_] == true,
                "Payment token does not in whitelist"
            );
            IERC20(paymentToken_).transferFrom(
                msg.sender,
                address(this),
                paymentAmount_
            );
            emit PaymentReceived(
                paymentToken_,
                paymentAmount_,
                msg.sender,
                tokenId_,
                tokenAmount_
            );
            _ds_app.lockedTokenVaultMap[tokenId_][
                paymentToken_
            ] += paymentAmount_;
        }

        _mint(msg.sender, tokenId_, tokenAmount_, "");
        emit MintCreatorToken(
            msg.sender,
            tokenId_,
            tokenAmount_,
            paymentToken_,
            paymentAmount_,
            nonce_
        );
    }

    event UnlockCreatorTokenFund(
        address sender,
        uint256 id,
        address tokenBuyer,
        uint256 tokenAmount,
        address paymentToken,
        uint256 paymentAmount,
        string nonce
    );

    function unlockCreatorTokenFund(
        uint256 id_,
        address tokenBuyer_,
        uint256 tokenAmount_,
        address paymentToken_,
        uint256 paymentAmount_,
        string memory nonce_,
        bytes memory signature_
    ) public {
        LibDiamond.enforceIsNotPaused();
        LibDiamond.verifySignatureAndUseNonce(
            abi.encodePacked(
                id_,
                tokenBuyer_,
                tokenAmount_,
                paymentToken_,
                paymentAmount_,
                nonce_
            ),
            nonce_,
            signature_,
            "Invalid signature"
        );

        if (paymentToken_ != address(0)) {
            AppStorage storage _ds_app = appStorage();
            require(
                _ds_app.paymentTokens[paymentToken_] == true,
                "Payment token does not exist"
            );
            require(
                _ds_app.lockedTokenVaultMap[id_][paymentToken_] >=
                    paymentAmount_,
                "Insufficient locked token vault amount"
            );
            _ds_app.lockedTokenVaultMap[id_][paymentToken_] -= paymentAmount_;
            uint256 platformProfit = (paymentAmount_ * _ds_app.feeRate) / 10000;
            _ds_app.platformProfitMap[paymentToken_] += platformProfit;
            _ds_app.unlockedTokenVaultMap[id_][paymentToken_] +=
                paymentAmount_ -
                platformProfit;

            uint256 balance = balanceOf(tokenBuyer_, _ds_app.VIP_NFT_TokenID);
            if (balance >= 1) {
                uint256 farmAmount = (paymentAmount_ * _ds_app.farmRate) /
                    10000;
                _mint(tokenBuyer_, _ds_app.ERC20_TokenID, farmAmount, "");
            }
        }

        emit UnlockCreatorTokenFund(
            msg.sender,
            id_,
            tokenBuyer_,
            tokenAmount_,
            paymentToken_,
            paymentAmount_,
            nonce_
        );
    }

    event CancelMintCreatorToken(
        address sender,
        address owner,
        uint256 id,
        uint256 tokenAmount,
        address paymentToken,
        uint256 paymentAmount
    );

    function cancelMintCreatorToken(
        uint256 id_,
        address owner_,
        uint256 tokenAmount_,
        address paymentToken_,
        uint256 paymentAmount_,
        string memory nonce_,
        bytes memory signature_
    ) public {
        LibDiamond.enforceIsNotPaused();
        LibDiamond.verifySignatureAndUseNonce(
            abi.encodePacked(
                id_,
                owner_,
                tokenAmount_,
                paymentToken_,
                paymentAmount_,
                nonce_
            ),
            nonce_,
            signature_,
            "Invalid signature"
        );

        if (paymentToken_ != address(0)) {
            AppStorage storage _ds_app = appStorage();
            require(
                _ds_app.paymentTokens[paymentToken_] == true,
                "Payment token does not exist"
            );
            require(
                _ds_app.lockedTokenVaultMap[id_][paymentToken_] >=
                    paymentAmount_,
                "Insufficient locked token vault amount"
            );
            _ds_app.lockedTokenVaultMap[id_][paymentToken_] -= paymentAmount_;
            IERC20(paymentToken_).transfer(owner_, paymentAmount_);

            ERC1155FacetStorage storage _ds = erc1155Storage();

            _ds._totalSupply[id_] -= tokenAmount_;
            _ds._balances[id_][owner_] -= tokenAmount_;
        }

        emit CancelMintCreatorToken(
            msg.sender,
            owner_,
            id_,
            tokenAmount_,
            paymentToken_,
            paymentAmount_
        );
    }

    // ========== application funcs end ==========

    function _mint(
        address to_,
        uint256 id_,
        uint256 amount_,
        bytes memory data_
    ) internal virtual {
        _requireNonZero(to_);

        ERC1155FacetStorage storage _ds = erc1155Storage();
        _requireNonZero(_ds._tokenOwner[id_]);

        _ds._totalSupply[id_] += amount_;
        _ds._balances[id_][to_] += amount_;

        emit TransferSingle(msg.sender, address(0), to_, id_, amount_);

        _requireReceiver(address(0), to_, id_, amount_, data_);
    }

    function uri(uint256 tokenID_) public view virtual returns (string memory) {
        ERC1155FacetStorage storage _ds = erc1155Storage();
        return string(abi.encodePacked(_ds._baseURI, tokenID_));
    }

    function totalSupply(uint256 id_) public view virtual returns (uint256) {
        ERC1155FacetStorage storage _ds = erc1155Storage();
        return _ds._totalSupply[id_];
    }

    function exists(uint256 id_) public view virtual returns (bool) {
        return totalSupply(id_) > 0;
    }

    function balanceOf(
        address account_,
        uint256 id_
    ) public view returns (uint256) {
        _requireNonZero(account_);
        ERC1155FacetStorage storage _ds = erc1155Storage();
        return _ds._balances[id_][account_];
    }

    function balanceOfBatch(
        address[] calldata accounts_,
        uint256[] calldata ids_
    ) external view returns (uint256[] memory) {
        require(
            accounts_.length == ids_.length,
            "ERC1155: accounts and ids length mismatch"
        );
        uint256[] memory batchBalances = new uint256[](accounts_.length);

        for (uint256 i = 0; i < accounts_.length; ++i) {
            batchBalances[i] = balanceOf(accounts_[i], ids_[i]);
        }

        return batchBalances;
    }

    function setApprovalForAll(address operator_, bool approved_) external {
        _setApprovalForAll(msg.sender, operator_, approved_);
    }

    function isApprovedForAll(
        address account_,
        address operator_
    ) public view returns (bool) {
        ERC1155FacetStorage storage _ds = erc1155Storage();
        return _ds._operatorApprovals[account_][operator_];
    }

    function safeTransferFrom(
        address from_,
        address to_,
        uint256 id_,
        uint256 amount_,
        bytes calldata data_
    ) external {
        _requireAuth(from_);
        _safeTransferFrom(from_, to_, id_, amount_, data_);
    }

    function safeBatchTransferFrom(
        address from_,
        address to_,
        uint256[] calldata ids_,
        uint256[] calldata amounts_,
        bytes calldata data_
    ) external {
        _requireAuth(from_);
        _safeBatchTransferFrom(from_, to_, ids_, amounts_, data_);
    }

    function _setApprovalForAll(
        address owner_,
        address operator_,
        bool approved_
    ) private {
        require(
            owner_ != operator_,
            "ERC1155: Cannot set approval status for self"
        );
        ERC1155FacetStorage storage _ds = erc1155Storage();
        _ds._operatorApprovals[owner_][operator_] = approved_;

        emit ApprovalForAll(owner_, operator_, approved_);
    }

    function _safeTransferFrom(
        address from_,
        address to_,
        uint256 id_,
        uint256 amount_,
        bytes memory data_
    ) private {
        _transfer(from_, to_, id_, amount_);

        emit TransferSingle(msg.sender, from_, to_, id_, amount_);
        _requireReceiver(from_, to_, id_, amount_, data_);
    }

    function _safeBatchTransferFrom(
        address from_,
        address to_,
        uint256[] memory ids_,
        uint256[] memory amounts_,
        bytes memory data_
    ) private {
        require(
            amounts_.length == ids_.length,
            "ERC1155: accounts and ids length mismatch"
        );

        for (uint256 _i = 0; _i < amounts_.length; ++_i) {
            _transfer(from_, to_, ids_[_i], amounts_[_i]);
        }

        emit TransferBatch(msg.sender, from_, to_, ids_, amounts_);
        _requireBatchReceiver(from_, to_, ids_, amounts_, data_);
    }

    function _transfer(
        address from_,
        address to_,
        uint256 id_,
        uint256 amount_
    ) private {
        _requireNonZero(to_);
        _requireBalance(from_, id_, amount_);
        _requireNotSBT(id_);
        ERC1155FacetStorage storage _ds = erc1155Storage();
        _ds._balances[id_][from_] -= amount_;
        _ds._balances[id_][to_] += amount_;
    }

    function _requireNotSBT(uint256 id_) private view {
        AppStorage storage _ds_app = appStorage();
        bool isSBT = id_ != _ds_app.ERC20_TokenID &&
            id_ != _ds_app.SR_NFT_TokenID &&
            id_ != _ds_app.VIP_NFT_TokenID &&
            id_ != _ds_app.Entropy_TokenID;
        require(!isSBT, "ERC1155: SBT cannot be transferred");
    }

    function _requireAuth(address account_) private view {
        require(
            account_ == msg.sender || isApprovedForAll(account_, msg.sender),
            "ERC1155: caller is not token owner or approved"
        );
    }

    function _requireNonZero(address account_) private pure {
        require(
            account_ != address(0),
            "ERC1155: address zero is not a valid owner"
        );
    }

    function _requireBalance(
        address account_,
        uint256 id_,
        uint256 amount_
    ) private view {
        ERC1155FacetStorage storage _ds = erc1155Storage();
        require(
            _ds._balances[id_][account_] >= amount_,
            "ERC1155: Insufficient balance"
        );
    }

    function _requireReceiver(
        address from_,
        address to_,
        uint256 tokenID_,
        uint256 amount_,
        bytes memory data_
    ) private {
        require(
            _checkOnERC1155Received(from_, to_, tokenID_, amount_, data_),
            "ERC1155: transfer to non ERC1155Receiver implementer"
        );
    }

    function _requireBatchReceiver(
        address from_,
        address to_,
        uint256[] memory tokenIDs_,
        uint256[] memory amounts_,
        bytes memory data_
    ) private {
        require(
            _checkOnERC1155BactchReceived(
                from_,
                to_,
                tokenIDs_,
                amounts_,
                data_
            ),
            "ERC1155: transfer to non ERC1155Receiver implementer"
        );
    }

    function _hasContract(address account_) private view returns (bool) {
        return account_.code.length > 0;
    }

    function _checkOnERC1155Received(
        address from_,
        address to_,
        uint256 tokenID_,
        uint256 amount_,
        bytes memory data_
    ) private returns (bool) {
        if (_hasContract(to_)) {
            try
                IERC1155Receiver(to_).onERC1155Received(
                    msg.sender,
                    from_,
                    tokenID_,
                    amount_,
                    data_
                )
            returns (bytes4 retval) {
                return retval == IERC1155Receiver.onERC1155Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC1155: transfer to non ERC1155Receiver implementer"
                    );
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _checkOnERC1155BactchReceived(
        address from_,
        address to_,
        uint256[] memory tokenIDs_,
        uint256[] memory amounts_,
        bytes memory data_
    ) private returns (bool) {
        if (_hasContract(to_)) {
            try
                IERC1155Receiver(to_).onERC1155BatchReceived(
                    msg.sender,
                    from_,
                    tokenIDs_,
                    amounts_,
                    data_
                )
            returns (bytes4 retval) {
                return retval == IERC1155Receiver.onERC1155Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC1155: transfer to non ERC1155Receiver implementer"
                    );
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}
