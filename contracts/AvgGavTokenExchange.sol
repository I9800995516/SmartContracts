// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenExchange {
    IERC20 public AvgToken;
    IERC20 public GavToken;
    address public owner;
    uint256 public tokenPrice; // Price in wei for one token

    event TokensPurchased(address indexed buyer, uint256 amount, string tokenSymbol);
    event TokensExchanged(address indexed exchanger, uint256 amount, string fromTokenSymbol, string toTokenSymbol);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(address _AvgToken, address _GavToken, uint256 _tokenPrice) {
        AvgToken = IERC20(_AvgToken);
        GavToken = IERC20(_GavToken);
        owner = msg.sender;
        tokenPrice = _tokenPrice;
    }

    function buyAvgTokens() external payable {
        uint256 amountToBuy = msg.value / tokenPrice;
        require(AvgToken.balanceOf(address(this)) >= amountToBuy, "Not enough AVG tokens in the contract");
        AvgToken.transfer(msg.sender, amountToBuy);
        emit TokensPurchased(msg.sender, amountToBuy, "AVG");
    }

    function buyGavTokens() external payable {
        uint256 amountToBuy = msg.value / tokenPrice;
        require(GavToken.balanceOf(address(this)) >= amountToBuy, "Not enough GAV tokens in the contract");
        GavToken.transfer(msg.sender, amountToBuy);
        emit TokensPurchased(msg.sender, amountToBuy, "GAV");
    }

    function exchangeAvgForGAV(uint256 amount) external {
        require(AvgToken.balanceOf(msg.sender) >= amount, "Not enough AVG tokens");
        require(GavToken.balanceOf(address(this)) >= amount, "Not enough GAV tokens in the contract");

        AvgToken.transferFrom(msg.sender, address(this), amount);
        GavToken.transfer(msg.sender, amount);
        emit TokensExchanged(msg.sender, amount, "AVG", "GAV");
    }

    function exchangeGAVForAvg(uint256 amount) external {
        require(GavToken.balanceOf(msg.sender) >= amount, "Not enough GAV tokens");
        require(AvgToken.balanceOf(address(this)) >= amount, "Not enough AVG tokens in the contract");

        GavToken.transferFrom(msg.sender, address(this), amount);
        AvgToken.transfer(msg.sender, amount);
        emit TokensExchanged(msg.sender, amount, "GAV", "AVG");
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function depositAvgTokens(uint256 amount) external onlyOwner {
        AvgToken.transferFrom(msg.sender, address(this), amount);
    }

    function depositGavTokens(uint256 amount) external onlyOwner {
        GavToken.transferFrom(msg.sender, address(this), amount);
    }
}
