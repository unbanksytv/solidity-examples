// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ONFT721Core.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// NOTE: this ONFT contract has no public minting logic.
// must implement your own minting logic in child classes
contract ONFT721 is ONFT721Core, ERC721 {
    constructor(
        string memory _name,
        string memory _symbol,
        address _lzEndpoint
    ) ERC721(_name, _symbol) ONFT721Core(_lzEndpoint) {}

    function _debitFrom(
        address _from,
        uint16, /* _dstChainId */
        bytes memory, /* _toAddress */
        uint _tokenId
    ) internal virtual override {
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ONFT721: send caller is not owner nor approved");
        require(ERC721.ownerOf(_tokenId) == _from, "ONFT721: send from incorrect owner");
        _burn(_tokenId);
    }

    function _creditTo(
        uint16, /* _srcChainId */
        address _toAddress,
        uint _tokenId
    ) internal virtual override {
        _safeMint(_toAddress, _tokenId);
    }
}
