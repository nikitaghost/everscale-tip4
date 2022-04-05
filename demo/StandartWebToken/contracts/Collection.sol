pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import '../../../contracts/TIP4_2/TIP4_2Collection.sol';
import '../../../contracts/access/OwnableExternal.sol';
import './Nft.sol';

contract Collection is TIP4_2Collection, OwnableExternal {

    /// _remainOnNft - the number of crystals that will remain after the entire mint 
    /// process is completed on the Nft contract
    uint128 _remainOnNft = 0.3 ever;

    /// @dev нужно ли дублировать переменные из json?
    /// Collection params
    string _name;
    string _symbol;
    uint128 _mintingFee;

    constructor(
        TvmCell codeNft, 
        uint256 ownerPubkey,
        string json,
        string name,
        string symbol,
        uint128 mintingFee
    ) OwnableExternal(
        ownerPubkey
    ) TIP4_1Collection (
        codeNft
    ) TIP4_2Collection (
        json
    ) public {
        tvm.accept();

        _name = name;
        _symbol = symbol;
        _mintingFee = mintingFee;
    }

    function mintNft(
        string json,
        uint8 royalty
    ) external virtual {
        require(msg.value > _remainOnNft + _mintingFee, CollectionErrors.value_is_less_than_required);
        /// reserve original_balance + _mintingFee 
        tvm.rawReserve(_mintingFee, 4);

        uint256 id = uint256(_totalSupply);
        _totalSupply++;

        TvmCell codeNft = _buildNftCode(address(this));
        TvmCell stateNft = _buildNftState(codeNft, id);
        address nftAddr = new Nft{
            stateInit: stateNft,
            value: 0,
            flag: 128
        }(
            msg.sender,
            msg.sender,
            msg.sender,
            _remainOnNft,
            json,
            royalty
        ); 

        emit NftCreated(
            id, 
            nftAddr,
            msg.sender,
            msg.sender, 
            msg.sender
        );
    
    }

    function withdraw(address dest, uint128 value) external pure onlyOwner {
        require(address(this).balance - value >= 10 ever, CollectionErrors.value_is_greater_than_the_balance);
        tvm.accept();
        dest.transfer(value, true);
    }

    function setRemainOnNft(uint128 remainOnNft) external virtual onlyOwner {
        _remainOnNft = remainOnNft;
    } 

    function name() external view responsible returns(string) {
        return {value: 0, flag: 64, bounce: false}(_name);
    }

    function symbol() external view responsible returns(string) {
        return {value: 0, flag: 64, bounce: false}(_symbol);
    }

    function mintingFee() external view responsible returns(uint128) {
        return {value: 0, flag: 64, bounce: false}(_mintingFee);
    }

    function _buildNftState(
        TvmCell code,
        uint256 id
    ) internal virtual override pure returns (TvmCell) {
        return tvm.buildStateInit({
            contr: Nft,
            varInit: {_id: id},
            code: code
        });
    }

}
