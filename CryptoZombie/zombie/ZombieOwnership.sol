pragma solidity ^0.4.0;

import "./erc721.sol";
import "./ZombieBattle.sol";

contract ZombieOwnership is ZombieBattle, ERC721 {
    //implement ERC721
    mapping (uint => address) approvals;

    function balanceOf(address _owner) public view returns (uint256 _balance){
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner){
        return zombieToOwner[_tokenId];
    }


    function _transfer(address _from, address _to, uint _tokenId) private{
        zombieToOwner[_tokenId] = _to;
        ownerZombieCount[_from]--;
        ownerZombieCount[_to]++;
        Transfer(_from,_to,_tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId){
        _transfer(msg.sender,_to,_tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId){
        approvals[_tokenId] = _to;
        Approval(msg.sender,_to,_tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(approvals[_tokenId] ==msgs.sender);
        address owner = ownerOf(_tokenId);
        _transfer(_owner,_msg.sender,_tokenId);
    }
}
