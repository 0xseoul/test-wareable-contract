/**
                                                             __ 
                                                            /  |
  ______   __    __   _______   ______    ______   __    __ $$ |
 /      \ /  \  /  | /       | /      \  /      \ /  |  /  |$$ |
/$$$$$$  |$$  \/$$/ /$$$$$$$/ /$$$$$$  |/$$$$$$  |$$ |  $$ |$$ |
$$ |  $$ | $$  $$<  $$      \ $$    $$ |$$ |  $$ |$$ |  $$ |$$ |
$$ \__$$ | /$$$$  \  $$$$$$  |$$$$$$$$/ $$ \__$$ |$$ \__$$ |$$ |
$$    $$/ /$$/ $$  |/     $$/ $$       |$$    $$/ $$    $$/ $$ |
 $$$$$$/  $$/   $$/ $$$$$$$/   $$$$$$$/  $$$$$$/   $$$$$$/  $$/ 
                                                                                                                                                                                                                                  
 */
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./interfaces/IWearable721.sol";

//
/**
  @title minting website NFT contract opensource
  @author web3.0 stevejobs
  @dev ERC721A contract for minting NFT tokens
*/
contract WEARABLE721 is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using SafeMath for uint256;

    // uint256 constant TOP = 0;
    // uint256 constant BOTTOM = 1;

    bytes32 public root;

    uint256 public maxMintAmountPerTx = 3;
    uint256 public maxSupply = 100;
    uint256 presaleAmountLimit = 3;

    string public baseURI;
    string public notRevealedUri =
        "ipfs://QmcXG9QgbBocXuXHA3HukSDGF9aAEi88niNMspwvqRmaNp.json";
    string public baseExtension = ".json";

    bool public paused = false;
    bool public revealed = false;
    bool public publicM = false;
    bool public presaleM = false;

    mapping(address => uint256) public _presaleClaimed;
    mapping(uint256 => IWEARABLE721.TokenInfo) public _tokenInfo;
    mapping(uint256 => mapping(uint256 => uint256)) public _tokenInfoMap;

    uint256 _price = 0; // 0.0 ETH
    // uint256 _price = 10**16; // 0.01 ETH

    address internal itemHandler;

    // constructor(bytes32 merkleroot)
    constructor() ERC721A("BoredApe Yacht Club", "BAYC") ReentrancyGuard() {
        maxSupply = 100;
        // root = merkleroot;
    }

    modifier isValidMerkleProof(bytes32[] calldata _proof) {
        require(
            MerkleProof.verify(
                _proof,
                root,
                keccak256(abi.encodePacked(msg.sender))
            ) == true,
            "0xWEARABLE721: merkle proof is not valid"
        );
        _;
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
            "0xWEARABLE721: Invalid mint amount!"
        );
        require(
            totalSupply() + _mintAmount <= maxSupply,
            "0xWEARABLE721: Max supply exceeded!"
        );
        _;
    }

    modifier mintPriceCompliance(uint256 _mintAmount, uint256 cost) {
        require(
            msg.value >= cost * _mintAmount,
            "0xWEARABLE721: Insufficient funds!"
        );
        _;
    }

    modifier onlyAccounts() {
        require(msg.sender == tx.origin, "0xWEARABLE721: Not allowed origin");
        _;
    }

    // 이거 바꾸기
    modifier onlyItemHandler() {
        require(
            msg.sender == itemHandler || msg.sender == owner(),
            "0xWEARABLE721: you're not using item handling contract"
        );
        _;
    }

    function toggleReveal() public onlyOwner {
        revealed = !revealed;
    }

    function togglePause() public onlyOwner {
        paused = !paused;
    }

    function togglePresale() public onlyOwner {
        presaleM = !presaleM;
    }

    function togglePublicSale() public onlyOwner {
        publicM = !publicM;
    }

    function getTokenInfo(uint256 _tokenId)
        external
        view
        returns (uint256[17] memory)
    {
        // IWEARABLE721.TokenInfo memory info =
        uint256[17] memory info;
        for (uint256 i = 0; i < 17; i++) {
            info[i] = _tokenInfoMap[_tokenId][i];
        }

        return info;
    }

    /**
            @dev 옷을 탈의하는 함수입니다.
            옷을 탈의 하는 경우, 해당 아이디를 mapping에서 찾아서, 해당 의류 아이디를 0으로 만듭니다.
          * @param _type 의류 종류
          * @param tokenId 아바타 토큰 아이디
          0 === hair / 1 === clothing / 2 === eyes / 3 === mouth
          4 === offHand / 5 === eyeWear / 6 === skin / 7 === background
          8 === additionalItem1 / 9 === additionalItem2 / 10 === additionalItem3 / 11 === additionalItem4
          12 === additionalItem5 / 13 === additionalItem6 / 14 === additionalItem7 / 15 === additionalItem8
          16 === additionalItem9 / 17 === additionalItem10 /
    */

    function dressDown(uint256 _type, uint256 tokenId)
        external
        onlyItemHandler
        nonReentrant
        returns (bool success)
    {
        require(
            _exists(tokenId),
            "0xWEARABLE721: Token does not exist, cannot dress down"
        );
        _tokenInfoMap[tokenId][_type] = 0;
        return false;
    }

    /**
            @dev 옷을 착용하는 함수입니다.
            옷을 착용 하는 경우, 해당 아이디를 mapping에서 찾아서, 해당 의류의 아이디를 넣습니다.
          * @param _type 의류 종류
          * @param tokenId 아바타 토큰 아이디
          * @param erc1155Id 의류 아이디

          0 === hair / 1 === clothing / 2 === eyes / 3 === mouth
          4 === offHand / 5 === eyeWear / 6 === skin / 7 === background
          8 === additionalItem1 / 9 === additionalItem2 / 10 === additionalItem3 / 11 === additionalItem4
          12 === additionalItem5 / 13 === additionalItem6 / 14 === additionalItem7 / 15 === additionalItem8
          16 === additionalItem9 / 17 === additionalItem10 /
    */

    function dressUp(
        uint256 _type,
        uint256 tokenId,
        uint256 erc1155Id
    ) external onlyItemHandler nonReentrant returns (bool success) {
        // require(_type == TOP || _type == BOTTOM, "0xWEARABLE721: Invalid type");
        require(_type >= 0 && _type <= 17, "0xWEARABLE721: Invalid type");
        _tokenInfoMap[tokenId][_type] = erc1155Id;
        return true;
    }

    function setItemHandler(address _itemHandler) public onlyOwner {
        itemHandler = _itemHandler;
    }

    function setBaseExtension(string memory _baseExtension) public onlyOwner {
        baseExtension = _baseExtension;
    }

    function setMerkleRoot(bytes32 merkleroot) public onlyOwner {
        root = merkleroot;
    }

    function setBaseURI(string memory _tokenBaseURI) public onlyOwner {
        baseURI = _tokenBaseURI;
    }

    function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
        public
        onlyOwner
    {
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    function setPublicSalePrice(uint256 _cost) public onlyOwner {
        _price = _cost;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function airdrop(uint256 _mintAmount, address _to) public onlyOwner {
        require(
            totalSupply() + _mintAmount <= maxSupply,
            "0xWEARABLE721: airdrop amount exceeds max supply"
        );
        _safeMint(_to, _mintAmount);
    }

    function presaleMint(
        address account,
        uint256 _amount,
        bytes32[] calldata _proof
    ) external payable isValidMerkleProof(_proof) onlyAccounts {
        uint256 _totalSupply = totalSupply();
        require(msg.sender == account, "0xWEARABLE721: Not allowed");
        require(presaleM, "0xWEARABLE721: Presale is OFF");
        require(!paused, "0xWEARABLE721: Contract is paused");
        require(
            _amount <= presaleAmountLimit,
            "0xWEARABLE721: You can't mint so much tokens"
        );
        require(
            _presaleClaimed[msg.sender] + _amount <= presaleAmountLimit,
            "0xWEARABLE721: You can't mint so much tokens"
        );

        require(
            _totalSupply + _amount <= maxSupply,
            "0xWEARABLE721: max supply exceeded"
        );
        require(
            _price * _amount <= msg.value,
            "0xWEARABLE721: Not enough ethers sent"
        );

        _presaleClaimed[msg.sender] += _amount;

        _safeMint(msg.sender, _amount);
    }

    function publicSaleMint(uint256 _amount)
        external
        payable
        mintCompliance(_amount)
        mintPriceCompliance(_amount, _price)
        onlyAccounts
    {
        require(publicM, "0xWEARABLE721: PublicSale is OFF");
        require(!paused, "0xWEARABLE721: Contract is paused");
        _safeMint(msg.sender, _amount);
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();

        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        _tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function withdraw() public onlyOwner nonReentrant {
        // This will pay nft-utilz 5% of the initial sale.
        // You can remove this if you want, or keep it in to support nft-utilz open source.
        // =============================================================================
        (bool abe, ) = payable(0x45E3Ca56946e0ee4bf36e893CC4fbb96A1523212).call{
            value: (address(this).balance * 5) / 100
        }("");
        require(abe, "0xabe721 5% of the initial sale");
        // =============================================================================

        // This will transfer the remaining contract balance to the owner.
        // Do not remove this otherwise you will not be able to withdraw the funds.
        // =============================================================================
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Transfer failed.");
    }
}
