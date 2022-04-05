// ItGold.io Contracts (v1.0.0) 

pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import '../../../contracts/TIP4_1/TIP4_1Nft.sol';
import '../../../contracts/TIP4_3/TIP4_3Nft.sol';
import '../../../contracts/TIP4_4/TIP4_4Nft.sol';


contract Nft is TIP4_1Nft, TIP4_3Nft, TIP4_4Nft {

    /// Author address
    address _author;

    /// Mapping royalty recipient to royalty value
    uint8 _royalty;

    /// Token params
    string _name;
    string _description;

    constructor(
        address owner,
        address sendGasTo,
        address author,
        uint128 remainOnNft,
        string name,
        string description,
        uint8 royalty,
        uint128 indexDeployValue,
        uint128 indexDestroyValue,
        TvmCell codeIndex,
        address storageAddr
    ) TIP4_1Nft(
        owner,
        sendGasTo,
        remainOnNft
    ) TIP4_3Nft (
        indexDeployValue,
        indexDestroyValue,
        codeIndex
    ) TIP4_4Nft (
        storageAddr
    ) public {
        tvm.accept();
    
        _author = author;
        _name = name;
        _description = description;
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

    function name() public view responsible returns(string nftName) {
        return {value: 0, flag: 64, bounce: false}(_name);
    }

    function description() public view responsible returns(string nftDescription) {
        return {value: 0, flag: 64, bounce: false}(_description);
    }

    function burn(address dest) external virtual onlyManager {
        tvm.accept();
        selfdestruct(dest);
    }

    modifier onlyManager virtual override(TIP4_1Nft, TIP4_4Nft) {
        require(msg.sender == _manager, NftErrors.sender_is_not_manager);
        require(_active);
        _;
    }

}