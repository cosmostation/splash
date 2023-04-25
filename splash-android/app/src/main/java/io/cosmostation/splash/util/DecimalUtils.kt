package io.cosmostation.splash.util

import kotlin.math.pow

object DecimalUtils {
    fun toString(amount: Double, decimal: Int = 9, trim: Int = 3): String {
        if (amount <= 0.0) {
            return "0.0"
        }
        return String.format("%.${trim}f", amount * 0.1.pow(decimal))
    }

    fun toString(amount: Long, decimal: Int = 9, trim: Int = 3): String {
        if (amount <= 0L) {
            return "0.0"
        }

        return String.format("%.${trim}f", amount * 0.1.pow(decimal))
    }
}