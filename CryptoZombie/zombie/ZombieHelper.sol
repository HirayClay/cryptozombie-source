pragma solidity ^0.4.0;

import "./ZombieFeeding.sol";
import "./ZombieFactory.sol";


contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;
    //restriction on ownership of zombie
    modifier onlyOwnerOf(uint _zombieId){
        require(msg.sender == zombieToOwner[_zombied]);
        _;
    }

    modifier aboveLevel(uint _zombieId, uint _level){
        require(zombies[_zombieId] >= _level);
        _;
    }

    function changeName(uint _zombieId, string _newName) aboveLevel(_zombieId, _newName) onlyOwnerOf(_zombieId) {
        //change name cause blockchain status chagne
        Zombie storage zombie = zombies[_zombieId];
        zombie.name = _newName;
    }


    function getZombiesByOwner(address _owner) public view returns (Zombie[]){
        Zombie[] memory ownerZombies = new Zombie[ownerZombieCount[_owner]];
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            // i is id
            Zombie zombie = zombieToOwner[i];
            if (zombieToOwner[i] == _owner) {
                ownerZombies[counter] = zombie;
                counter++;
            }
        }
        return ownerZombies;
    }

    function levelUp(uint _zombieId) external payable onlyOwnerOf(_zombieId) {
        if (msg.value >= levelUpFee) {
            zombies[_zombieId]++;
            //send back the overpaid
            msg.sender.transfer(msg.value-levelUpFee);
        }
        /*else{
            this.levelUp.selector;
        }*/

    }
}
