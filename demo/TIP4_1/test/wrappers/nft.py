from re import L
import tonos_ts4.ts4 as ts4
from tonclient.types import CallSet

from wrappers.setcode import Setcode
from config import *


class Nft(ts4.BaseContract):

    def __init__(self, address: ts4.Address, nft_owner: Setcode):
        super().__init__('Nft', {}, nickname="Nft", address=address)
        self.nft_owner = nft_owner

    @property
    def id(self) -> ts4.Address:
        return self.call_responsible('getInfo')[ID_KEY]

    @property
    def owner(self) -> ts4.Address:
        return self.call_responsible('getInfo')[OWNER_KEY]

    @property
    def manager(self) -> ts4.Address:
        return self.call_responsible('getInfo')[MANAGER_KEY]
    
    @property
    def collection(self) -> ts4.Address:
        return self.call_responsible('getInfo')[COLLECTION_KEY]

    def call_responsible(self, name: str, params: dict = None):
        if params is None:
            params = dict()
        params['answerId'] = 0
        return self.call_getter(name, params)

    def get_info(self) -> dict:
        return self.call_responsible('getInfo')

    def change_owner(
        self,
        new_owner,
        send_gas_to,
        callbacks,
        change_value,
        expect_ec
    ):
        call_set = CallSet('changeOwner', input={
            'newOwner': new_owner,
            'sendGasTo': send_gas_to,
            'callbacks': callbacks
        })
        self.owner.send_call_set(self, value=change_value, call_set=call_set, expect_ec=expect_ec)

    def change_manager(
        self,
        new_manager,
        send_gas_to,
        callbacks,
        change_value,
        expect_ec
    ):
        call_set = CallSet('changeManager', input={
            'newManager': new_manager,
            'sendGasTo': send_gas_to,
            'callbacks': callbacks
        })
        self.owner.send_call_set(self, value=change_value, call_set=call_set, expect_ec=expect_ec)

    def check_state(
        self,
        expected_nft_owner: ts4.Address,
        expected_nft_manager: ts4.Address,
        expected_collection: ts4.Address,
        expected_nft_balance: int = REMAIN_ON_NFT_VALUE
    ): 
        assert self.owner == expected_nft_owner, f'Wrong token owner exp: {self.owner}, given: {expected_nft_owner}'
        assert self.manager == expected_nft_manager, f'Wrong token manager exp: {self.manager}, given: {expected_nft_manager}'
        assert self.collection == expected_collection, f'Wrong token creator(collection) exp: {self.collection}, given: {expected_collection}'
        assert self.balance == expected_nft_balance, f'Wrong balance exp: {self.balance}, given: {expected_nft_balance}'