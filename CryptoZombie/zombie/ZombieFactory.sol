pragma solidity ^0.4.0;

import "./Ownable.sol";

contract ZombieFactory is Ownable {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    mapping(uint => address) zombieToOwner;
    mapping(address => uint) ownerZombieCount;

    event NewZombie (uint zombieId, string name, uint dna);

    struct Zombie {
        string name;
        uint dna;
        uint level;
        uint readyTime;
    }

    Zombie[] public zombies;
    modifier onlyOwnerOf(uint _zombieId){
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }
    modifier createOnlyOnce{
        require(ownerZombieCount[msg.sender] == 0);
        _;
    }

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, now + cooldownTime)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, dna);
    }

    /**
    让外部调用，创建一只僵尸，但每个用户只允许调用一次,用createOnlyOnce修饰符来限定
    **/
    function createRandomZombie(string _name) public createOnlyOnce {
        _createZombie(_name, _generateRandomDna(_name));
    }
    /**
   根据str 进行hash之后获取dna
        **/
    function _generateRandomDna(string _str) private view returns (uint){
        return rand = keccak256(_str) % dnaModulus;
    }


    function typeCast() external {
        uint8 a = 5;
        uint b = 6;
        uint8 = a * uint8(b);
    }
}

