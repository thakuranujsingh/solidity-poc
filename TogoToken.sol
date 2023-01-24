// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/proxy/utils/UUPSUpgradeable.sol";
import "hardhat/console.sol";

// import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract TogoToken is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    uint256 fixedValue = 0.00001 ether;
    AggregatorV3Interface internal priceFeed;
    IERC20 private linkToken;
    

    function initialize() initializer public {
        __ERC20_init("TogoToken", "TGK");
        __Ownable_init();
        __UUPSUpgradeable_init();
        priceFeed = AggregatorV3Interface(0x12162c3E810393dEC01362aBf156D7ecf6159528); //LINK / MATIC ploygon test net
        linkToken = IERC20(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);

         _mint(msg.sender, 7000000000 * 10 ** decimals());
    }

    function changeFixedValue(uint256 _value) public onlyOwner {
        fixedValue =  _value;
    }

    function getLINKContractAddress() public view returns(address) {
        return address(linkToken);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}


    function getLatestPrice() public view returns (uint256) {
        (
            ,
            int _price,
            ,,
        ) = priceFeed.latestRoundData();

        return uint256(_price);
    }


    function buyTGK(uint256 _value) public payable {
        require(msg.value >= _value * fixedValue, "Insufficient ether to buy TGK tokens.");
        uint256 tokens = _value / fixedValue;
        _mint(msg.sender, tokens * 10 ** decimals());

        emit Transfer(address(this), msg.sender, tokens);
    }

    function sellTGK(uint256 _value) public {
        require(balanceOf(msg.sender) >= _value * 10 ** decimals(), "Insufficient TGK tokens to sell");
        uint256  _ether = (_value * fixedValue);
        uint256 tokens = _value * 10 ** decimals();
        _burn(msg.sender, tokens);
        
        payable(address(this)).transfer(_ether);
        emit Transfer(msg.sender, address(this), tokens);
    }

     function exchangeTGKforLINK(uint256 _value) public {
        // require(balanceOf(msg.sender) >= _value * 10 ** decimals(), "Insufficient TGK tokens to exchange.");
        // _burn(msg.sender, _value * 10 ** decimals());
        // totalSupply -= _value;
        // uint256 _ether = _value * fixedValue;
        // // Get the current price of Y tokens 100 eth
        // uint256 price = getLatestPrice();
        // // Calculate the number of Y tokens to be received 
        // uint256 _linkTokens = _ether / price;
        //  console.log(
        //         "Transferring tokens to %s",
        //            _linkTokens
        //     );

        // Transfer the Y tokens to the user
        // require(transferFrom(msg.sender, address(this), _value), "Transfer TGK failed");
        // Owner, spender
        // transferFrom(msg.sender, address(this), _value);
        transfer(address(this), _value);
        linkToken.transfer(msg.sender, _value);
        
        emit Transfer(msg.sender, address(this), _value);
        emit Transfer(address(this), msg.sender, _value);
    }

    function linkTokenBalance(address walletAddress) public  view  returns (uint256) {
        return linkToken.balanceOf(walletAddress);
    }

}
