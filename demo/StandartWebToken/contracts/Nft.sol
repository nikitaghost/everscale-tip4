// ItGold.io Contracts (v1.0.0) 

pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import '../../../contracts/TIP4_1/TIP4_1Nft.sol';
import '../../../contracts/TIP4_2/TIP4_2Nft.sol';

contract Nft is TIP4_1Nft, TIP4_2Nft {

    /// Author address
    address _author;

    /// Mapping royalty recipient to royalty value
    uint8 _royalty;

    constructor(
        address owner,
        address sendGasTo,
        address author,
        uint128 remainOnNft,
        string json,
        uint8 royalty
    ) TIP4_1Nft(
        owner,
        sendGasTo,
        remainOnNft
    ) TIP4_2Nft (
        json
    ) public {
        tvm.accept();

        _author = author;
        _royalty = royalty;
    }

    function author() public view responsible returns(address authorAddr) {
        return {value: 0, flag: 64, bounce: false}(_author);
    }

    function royalty() public view responsible returns(uint8 royaltyValue) {
        return {value: 0, flag: 64, bounce: false}(_royalty);
    }

    function burn(address dest) external virtual onlyManager {
        tvm.accept();
        selfdestruct(dest);
    }

}