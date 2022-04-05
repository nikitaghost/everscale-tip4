// ItGold.io Contracts (v1.0.0) 

pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import '../../../contracts/TIP4_1/TIP4_1Nft.sol';
import '../../../contracts/TIP4_2/TIP4_2Nft.sol';
import '../../../contracts/TIP4_3/TIP4_3Nft.sol';


contract Nft is TIP4_1Nft, TIP4_2Nft, TIP4_3Nft {

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
        uint8 royalty,
        uint128 indexDeployValue,
        uint128 indexDestroyValue,
        TvmCell codeIndex
    ) TIP4_1Nft(
        owner,
        sendGasTo,
        remainOnNft
    ) TIP4_2Nft (
        json
    ) TIP4_3Nft (
        indexDeployValue,
        indexDestroyValue,
        codeIndex
    ) public {
        tvm.accept();

        _author = author;
        _royalty = royalty;
    }

    function _beforeChangeOwner(
        address oldOwner, 
        address newOwner,
        address sendGasTo, 
        mapping(address => CallbackParams) callbacks
    ) internal virtual override(TIP4_1Nft, TIP4_3Nft) {
        TIP4_3Nft._beforeChangeOwner(oldOwner, newOwner, sendGasTo, callbacks);
    }   

    function _afterChangeOwner(
        address oldOwner, 
        address newOwner,
        address sendGasTo, 
        mapping(address => CallbackParams) callbacks
    ) internal virtual override(TIP4_1Nft, TIP4_3Nft) {
        TIP4_3Nft._afterChangeOwner(oldOwner, newOwner, sendGasTo, callbacks);
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