// ItGold.io Contracts (v1.0.0) 

pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import '../../../TIP4_1/TIP4_1Nft.sol';
import '../../../TIP4_2/TIP4_2Nft.sol';

contract Nft is TIP4_1Nft, TIP4_2Nft {

    string _name;

    constructor(
        address owner,
        address sendGasTo,
        uint128 remainOnNft,
        string json,
        string name
    ) TIP4_1Nft(
        owner,
        sendGasTo,
        remainOnNft
    ) TIP4_2Nft (
        json
    ) public {
        tvm.accept();

        _name = name;

    }
    
    function getName() external view responsible returns (string name) {
        return {value: 0, flag: 64} (_name);
    }

}