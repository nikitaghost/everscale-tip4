async function main() {
  const Collection = await locklift.factory.getContract('Collection');
  const Nft = await locklift.factory.getContract('Nft');
  const Index = await locklift.factory.getContract('../../../TIP4_3/compiled/Index');
  const IndexBasis = await locklift.factory.getContract('../../../TIP4_3/compiled/IndexBasis');
  const [keyPair] = await locklift.keys.getKeyPairs();
  const ownerPubkey = "0x440d2f6fe861c43007fe4e16e1531291200d3245a6bc6dfb931edd97a68a2e63";
  
  const collection = await locklift.giver.deployContract({
    contract: Collection,
    constructorParams: {
      codeNft : Nft.code, 
      ownerPubkey : ownerPubkey,
      codeIndex : Index.code,
      codeIndexBasis : IndexBasis.code
    },
    initParams: {},
    keyPair,
  }, locklift.utils.convertCrystal(1, 'nano'));
  
  console.log(`Collection deployed at: ${collection.address}`);
}

main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });
