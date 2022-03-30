pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import '../access/OwnableExternal.sol';
import './interfaces/ITIP4_1Collection.sol';
import './errors/CollectionErrors.sol';
import './TIP4_1Nft.sol';


contract TIP4_1Collection is ITIP4_1Collection, OwnableExternal {
    
    TvmCell _codeNft;
    uint128 _totalSupply;

    constructor(TvmCell codeNft, uint256 ownerPubkey) OwnableExternal(ownerPubkey) public {
        tvm.accept();

        _codeNft = codeNft;
    }

    function totalSupply() external view virtual override responsible returns (uint128 count) {
        return {value: 0, flag: 64, bounce: false} (_totalSupply);
    }

    function nftCode() external view virtual override responsible returns (TvmCell code) {
        return {value: 0, flag: 64, bounce: false} (_buildNftCode(address(this)));
    }

    function nftCodeHash() external view virtual override responsible returns (uint256 codeHash) {
        return {value: 0, flag: 64, bounce: false} (resolveCodeHashNft());
    }

    function nftAddress(uint256 id) external view virtual override responsible returns (address nft) {
        return {value: 0, flag: 64, bounce: false} (resolveNft(address(this), id));
    }

    function resolveCodeHashNft() public view responsible returns (uint256 codeHashData) {
        return {value: 0, flag: 64, bounce: false}(tvm.hash(_buildNftCode(address(this))));
    }

    function resolveNft(
        address addrRoot,
        uint256 id
    ) public view responsible returns (address addrNft) {
        TvmCell code = _buildNftCode(addrRoot);
        TvmCell state = _buildNftState(code, id);
        uint256 hashState = tvm.hash(state);
        addrNft = address.makeAddrStd(0, hashState);
        return {value: 0, flag: 64, bounce: false} (addrNft);
    }

    function _buildNftCode(address addrRoot) internal virtual view returns (TvmCell) {
        TvmBuilder salt;
        salt.store(addrRoot);
        return tvm.setCodeSalt(_codeNft, salt.toCell());
    }

    function _buildNftState(
        TvmCell code,
        uint256 id
    ) internal virtual pure returns (TvmCell) {
        return tvm.buildStateInit({
            contr: TIP4_1Nft,
            varInit: {_id: id},
            code: code
        });
    }

}