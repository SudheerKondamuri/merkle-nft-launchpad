// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Imports
import "erc721a/contracts/ERC721A.sol"; // Gas-efficient batch minting
import "@openzeppelin/contracts/access/Ownable.sol"; // Access control
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; // Merkle proof verification
import "@openzeppelin/contracts/utils/Strings.sol"; // String utilities

contract MyNFT is ERC721A, Ownable {
    using Strings for uint256;

    // State Variables
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public price = 0.05 ether;
    bytes32 public merkleRoot; // Merkle root for allowlist verification

    string public baseURI; // Base URI for revealed token metadata
    string public notRevealedURI; // Placeholder URI for unrevealed tokens
    bool public revealed = false;
    bool public paused = true;

    // Constructor
    constructor(
        string memory _initNotRevealedUri,
        string memory  _name,
        string memory _symbol

    ) ERC721A(_name, _symbol) Ownable(msg.sender) {
        notRevealedURI = _initNotRevealedUri;
    }

    // Allows allowlisted addresses to mint NFTs
    function allowlistMint(
        uint256 quantity,
        bytes32[] calldata proof
    ) external payable {
        // Validation checks
        require(!paused, "Sale is paused");
        require(_totalMinted() + quantity <= MAX_SUPPLY, "Sold out!");
        require(msg.value >= price * quantity, "Not enough ETH");

        // Verify sender is included in the allowlist using Merkle proof
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(proof, merkleRoot, leaf),
            "Not on allowlist"
        );

        // Mint tokens
        _mint(msg.sender, quantity);
    }

    // Reveals metadata by setting the base URI
    function reveal(string memory _newBaseURI) external onlyOwner {
        revealed = true;
        baseURI = _newBaseURI;
    }

    // Returns token URI based on reveal state
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(_exists(tokenId), "Token doesn't exist");

        if (revealed == false) {
            return notRevealedURI;
        }

        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    // Withdraws contract balance to owner
    function withdraw() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Transfer failed");
    }
    
}
