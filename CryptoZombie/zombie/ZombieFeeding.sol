pragma solidity ^0.4.0;

import "./ZombieFactory.sol";
import "./KittyInterface.sol";

contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyInterface;
    function setKittyContractAddress(address _ckAddress) external{
        kittyInterface = KittyInterface(_ckAddress);
    }
    /**

    eat a target and the target was turned into a new zombie who owns
    new dna depending on origin and the predator's dna
     **/
    function multiplyAfterFeeding(uint _zombieId, uint _targetDna){
        Zombie zombie = zombies[_zombieId];
        uint newDna = (_targetDna % dnaModules + zombie.dna) / 2;
        Zombie newZombie = _createZombie("unknown", newDna);
        uint id = zombies.push(newZombie);
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, newZombie.name, newZombie.dna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId){
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyInterface.getKitty(_kittyId);
        multiplyAfterFeeding(_zombieId,kittyDna);

    }
}