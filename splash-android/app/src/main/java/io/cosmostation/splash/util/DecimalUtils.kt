package io.cosmostation.splash.util

import java.math.BigDecimal
import java.math.RoundingMode

object DecimalUtils {
    fun toString(amount: Double, decimal: Int = 9, trim: Int = 3): String {
        if (amount <= 0.0) {
            return "0.0"
        }
        return BigDecimal(amount).multiply(BigDecimal(0.1).pow(decimal)).setScale(trim, RoundingMode.DOWN).toString()
    }

    fun toString(amount: Long, decimal: Int = 9, trim: Int = 3): String {
        if (amount <= 0L) {
            return "0.0"
        }
        return BigDecimal(amount).multiply(BigDecimal(0.1).pow(decimal)).setScale(trim, RoundingMode.DOWN).toString()
    }
}