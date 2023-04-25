package io.cosmostation.splash.model.network

data class TransactionBlock(val txBlock: String, val address: String, val rpc: String)

data class StakeRequest(val validatorAddress: String, val address: String, val amount: String, val rpc: String)

data class UnstakeRequest(val objectId: String, val address: String, val rpc: String)
