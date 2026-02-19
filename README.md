# File Structure for referencing (dev)


```shell
merkle-nft-launchpad/
├── assets/                   # THE "ACTUAL DATA"
│   ├── layers/               # PNG layers (Background, Eyes, Hat)
│   ├── output/               # Final 10k Images + JSON (Before IPFS upload)
│   └── allowlist.json        # List of addresses for the Merkle Tree
├── contracts/                # THE "LEDGER"
│   └── SudheerNFT.sol        # Your ERC721A + Merkle contract
├── scripts/                  # THE "GLUE" (JavaScript/Node)
│   ├── generate-art.js       # Combines layers into 10k unique NFTs
│   ├── generate-merkle.js    # Turns allowlist.json into the Merkle Root
│   ├── deploy.js             # Deploys contract to Hardhat/Testnet
│   └── upload-to-ipfs.js     # Sends 'output/' folder to Pinata/IPFS
├── frontend/                 # THE "USER INTERFACE" (Next.js)
│   ├── components/           # Mint buttons, wallet connect
│   ├── constants/            # Stores Contract Address + ABI
│   └── pages/                # The website logic
├── docker-compose.yml        # Orchestrates the Blockchain + Frontend
├── hardhat.config.js         # Ethereum development settings
└── package.json              # Project dependencies (erc721a, ethers, etc.)
```
