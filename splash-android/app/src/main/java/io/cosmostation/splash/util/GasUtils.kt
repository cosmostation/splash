package io.cosmostation.splash.util

import io.cosmostation.splash.SplashConstants
import io.cosmostation.suikotlin.SuiClient

object GasUtils {
    private const val DEFAULT_GAS_BUDGET = 2000000
    private const val STAKE_GAS_BUDGET = 4000000
    private const val UNSTAKE_GAS_BUDGET = 4000000

    fun getDefaultGas(): Long {
        try {
            SplashConstants.suiFees?.get("sui-${SuiClient.instance.currentNetwork.name.lowercase()}")?.get("default")?.let {
                return it
            } ?: return DEFAULT_GAS_BUDGET.toLong()
        } catch (_: Exception) {
            return DEFAULT_GAS_BUDGET.toLong()
        }
    }

    fun getStakeGas(): Long {
        try {
            SplashConstants.suiFees?.get("sui-${SuiClient.instance.currentNetwork.name.lowercase()}")?.get("stake")?.let {
                return it
            } ?: return STAKE_GAS_BUDGET.toLong()
        } catch (_: Exception) {
            return STAKE_GAS_BUDGET.toLong()
        }
    }

    fun getUnstakeGas(): Long {
        try {
            SplashConstants.suiFees?.get("sui-${SuiClient.instance.currentNetwork.name.lowercase()}")?.get("unstake")?.let {
                return it
            } ?: return UNSTAKE_GAS_BUDGET.toLong()
        } catch (_: Exception) {
            return UNSTAKE_GAS_BUDGET.toLong()
        }
    }
}