pragma solidity ^0.4.0;

import "./ZombieFactory.sol";
import "./KittyInterface.sol";

contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyInterface;

    function setKittyContractAddress(address _ckAddress) external onlyOwner {
        kittyInterface = KittyInterface(_ckAddress);
    }
    /**

    eat a target and the target was turned into a new zombie who owns
    new dna depending on origin and the predator's dna
     **/
    function multiplyAfterFeeding(uint _zombieId, uint _targetDna, string _species)internal{
        Zombie zombie = zombies[_zombieId];
        require(_isReady(zombie.readyTime))

        uint newDna = (_targetDna % dnaModulus + zombie.dna) / 2;
        //if the zombie was transformed from a cat,we set the last two digits of DNA to 99
        if (keccak256("kitty") == keccak256(_species)) {
            newDna = newDna - newDna % 100 + 99;
        }
        Zombie newZombie = _createZombie("unknown", newDna);
        uint id = zombies.push(newZombie) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, newZombie.name, newZombie.dna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId){
        uint kittyDna;
        (, ,,,,,,,, kittyDna) = kittyInterface.getKitty(_kittyId);
        multiplyAfterFeeding(_zombieId, kittyDna, "kitty");

    }

    function _triggerCooldown(Zombie storage _zombie){
        _zombie.readyTime = now + cooldownTime;
    }

    function _isReady(Zombie storage _zombie) private returns (bool){
        return _zombie.readyTime <= now;
    }
}