// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Rookie is
    ERC721,
    ERC721URIStorage,
    ERC721Burnable,
    ERC721Enumerable,
    Ownable
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_LIMIT = 10;
    uint256 public totalAssignedNfts;
    uint256[MAX_LIMIT] nftIdList;

    event NFTAssigned(address indexed receiver, uint256 indexed tokenId);

    constructor() ERC721("Rookie", "RK") {}

    function safeMint(string[] memory uri) public onlyOwner {
        for (uint256 i = 0; i < uri.length; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            require(tokenId <= MAX_LIMIT, "Rookie: Exceeds Limit");
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, uri[i]);
        }
    }

    function assignRandomNft(uint256 salt, address receiver) public onlyOwner {
        uint256 randomNftId = getRandomNftId(salt);
        transferFrom(msg.sender, receiver, randomNftId);
        emit NFTAssigned(receiver, randomNftId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return
            "https://ipfs.io/ipfs/QmYhdGDnYzb6Z82QzEf5KPUVAUH6i62nhsVnJTiRTRea9i/";
    }

    function getRandomNftId(
        uint256 salt
    ) private returns (uint256 randomNftId) {
        require(
            totalAssignedNfts < MAX_LIMIT,
            "Rookie: No more NFTs to assign"
        );
        uint256 randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao, salt))
        );
        uint256 _totalAssignedNfts = totalAssignedNfts;
        totalAssignedNfts += 1;
        uint256 remainingNftCount = MAX_LIMIT - _totalAssignedNfts;
        uint256 randomNftIdIndex = randomNumber % remainingNftCount;
        if (nftIdList[randomNftIdIndex] == 0) {
            randomNftId = randomNftIdIndex;
        } else {
            randomNftId = nftIdList[randomNftIdIndex];
        }
        if (nftIdList[remainingNftCount - 1] == 0) {
            nftIdList[randomNftIdIndex] = remainingNftCount - 1;
        } else {
            nftIdList[randomNftIdIndex] = nftIdList[remainingNftCount - 1];
            delete nftIdList[remainingNftCount - 1];
        }
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
