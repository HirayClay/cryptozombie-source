pragma solidity ^0.4.0;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper{

    function attack(uint _zombieId,uint _targetId) onlyOwnerOf(_zombieId){

    }

}
