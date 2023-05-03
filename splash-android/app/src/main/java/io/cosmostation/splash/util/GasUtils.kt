package io.cosmostation.splash.util

import io.cosmostation.splash.SplashConstants
import io.cosmostation.suikotlin.SuiClient
import java.math.BigInteger

object GasUtils {
    private const val DEFAULT_GAS_BUDGET = "2000000"
    private const val STAKE_GAS_BUDGET = "4000000"
    private const val UNSTAKE_GAS_BUDGET = "4000000"

    fun getDefaultGas(): BigInteger {
        try {
            SplashConstants.suiFees?.get("sui-${SuiClient.instance.currentNetwork.name.lowercase()}")?.get("default")?.let {
                return BigInteger(it)
            } ?: return BigInteger(DEFAULT_GAS_BUDGET)
        } catch (_: Exception) {
            return BigInteger(DEFAULT_GAS_BUDGET)
        }
    }

    fun getStakeGas(): BigInteger {
        try {
            SplashConstants.suiFees?.get("sui-${SuiClient.instance.currentNetwork.name.lowercase()}")?.get("stake")?.let {
                return BigInteger(it)
            } ?: return BigInteger(STAKE_GAS_BUDGET)
        } catch (_: Exception) {
            return BigInteger(STAKE_GAS_BUDGET)
        }
    }

    fun getUnstakeGas(): BigInteger {
        try {
            SplashConstants.suiFees?.get("sui-${SuiClient.instance.currentNetwork.name.lowercase()}")?.get("unstake")?.let {
                return BigInteger(it)
            } ?: return BigInteger(UNSTAKE_GAS_BUDGET)
        } catch (_: Exception) {
            return BigInteger(UNSTAKE_GAS_BUDGET)
        }
    }
}