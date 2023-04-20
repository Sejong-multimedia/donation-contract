// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyToken is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct TokenData {
        uint256 Watering;
        uint256 Date;
        uint256 CreatedTime;
        string Goal;
        uint256 Staked;
        address DonationContract;
    }
    mapping(uint256 => TokenData) private _tokenData;

    mapping(address => uint256[]) private idByAddress;

    function addAddress(address _address, uint256 _id) public {
        idByAddress[_address].push(_id);
    }

    constructor() ERC721("MyToken", "MTK") {}

    string private _startTokenImageURI = "https://gateway.pinata.cloud/ipfs/QmUZgLZ4Z7G6d5dFikgUGrWDMwzhWjtd1UGBtUvUZH2or3";
    string private _middleTokenImageURI = "https://gateway.pinata.cloud/ipfs/QmSp4qqgsH5peCZaNt3gHTznjNcT7nr9PDccHVoNbXyZyp";
    string private _finalTokenImageURI = "https://gateway.pinata.cloud/ipfs/QmXsJGW2YJDtD3G9q2aYLA7BKmT9evVrCoXmdk3fws1ocf";

    function safeMint(address to, uint256 date, string memory goal, uint256 staked, address donationContract) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _startTokenImageURI);
        _tokenData[tokenId].Watering = 0;
        _tokenData[tokenId].Date = date;
        _tokenData[tokenId].CreatedTime = block.timestamp; // set the creation time
        _tokenData[tokenId].Goal = goal;
        _tokenData[tokenId].Staked = staked;
        _tokenData[tokenId].DonationContract = donationContract;
        addAddress(to, tokenId);
    }

    function getWatering(uint256 tokenId) public view returns (uint256) {
        return _tokenData[tokenId].Watering;
    }

    function getDate(uint256 tokenId) public view returns (uint256) {
        return _tokenData[tokenId].Date;
    }

    function getCreatedTime(uint256 tokenId) public view returns (uint256) {
        return _tokenData[tokenId].CreatedTime;
    }

    function getGoal(uint256 tokenId) public view returns (string memory) {
        return _tokenData[tokenId].Goal;
    }
    
    function getStaked(uint256 tokenId) public view returns(uint256) {
        return _tokenData[tokenId].Staked;
    }

    function getDonationContract(uint256 tokenId) public view returns(address) {
        return _tokenData[tokenId].DonationContract;
    }

    function getAllCharacter(uint256 tokenId) public view returns(TokenData memory) {
        return _tokenData[tokenId];
    }

    function getNftListOfHolder(address holder) public view returns (uint256[] memory) {
        return idByAddress[holder];
    }

    function increaseWatering(uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "MyToken: caller is not owner nor approved");
        if (_tokenData[tokenId].Watering != _tokenData[tokenId].Date) {
            _tokenData[tokenId].Watering += 1;
        }

        if (_tokenData[tokenId].Watering >= _tokenData[tokenId].Date/2) {
            _setTokenURI(tokenId, _middleTokenImageURI);
        } else if (_tokenData[tokenId].Watering >= _tokenData[tokenId].Date) {
            _setTokenURI(tokenId, _finalTokenImageURI);
        }
    }
}
