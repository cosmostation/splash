package io.cosmostation.splash.util

import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.EditText
import java.math.BigDecimal
import java.math.RoundingMode
import java.text.SimpleDateFormat
import java.util.*

fun Date.formatToViewTimeDefaults(): String {
    val sdf = SimpleDateFormat("MMM dd, hh:mm aa", Locale.US)
    return sdf.format(this)
}

fun View.visibleOrGone(visible: Boolean) {
    visibility = if (visible) View.VISIBLE else View.GONE
}

fun View.visibleOrInvisible(visible: Boolean) {
    visibility = if (visible) View.VISIBLE else View.INVISIBLE
}

fun EditText.addDecimalCheckListener(max: () -> String, decimal: Int) {
    val editText = this
    this.addTextChangedListener(object : TextWatcher {
        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
            s?.let {
                if (it.isBlank()) {
                    return
                }

                val inputAmount = BigDecimal(it.toString())
                val available = BigDecimal(max())
                if (inputAmount > available) {
                    editText.setText(max())
                    editText.setSelection(editText.length())
                }
                if (inputAmount.scale() > decimal) {
                    editText.setText(BigDecimal(it.toString()).setScale(decimal, RoundingMode.DOWN).toString())
                    editText.setSelection(editText.length())
                }
            }
        }

        override fun afterTextChanged(s: Editable?) {
        }
    })
}