pragma solidity ^0.4.0;

import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;
    uint attackWinProbability = 70;

    function produceModRandom(uint _modulus) internal returns (uint){
        randNonce++;
        return keccak256(now, msg.sender,randNonce);
    }

    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = produceModRandom(100);
        // 70% win rate;
        if (rand <= attackWinProbability) {
            myZombie.winCount++;
            enemyZombie.lossCount++;
            multiplyAfterFeeding(_zombieId, enemyZombie.dna, "zombie");
        }else{
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }

}
