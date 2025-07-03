package io.cosmostation.splash.ui.password

import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import com.walletconnect.util.Empty
import io.cosmostation.splash.R
import io.cosmostation.splash.databinding.ActivityPasswordBinding
import io.cosmostation.splash.util.Prefs
import org.apache.commons.lang3.StringUtils

class PinActivity : AppCompatActivity() {
    private lateinit var adapter: PinAdapter
    private lateinit var binding: ActivityPasswordBinding
    private lateinit var pinImages: List<View>
    private var inputPins: MutableList<String> = mutableListOf()
    private var needConfirmPins: String = ""
    private var type: Type = Type.Input
    private var confirmMode: Boolean = false

    companion object {
        const val DELETE_CODE = "D"
        const val CODE_LENGTH = 4
    }

    enum class Type {
        Input, Register
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPasswordBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupViews()
        type = if (Prefs.pin.isBlank()) {
            Type.Register
        } else {
            Type.Input
        }
        reset()
    }

    private fun setupViews() {
        pinImages = listOf(binding.pin1, binding.pin2, binding.pin3, binding.pin4)
        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        adapter = PinAdapter(this) { processInput(it) }
        binding.recycler.layoutManager = GridLayoutManager(this, 3)
        binding.recycler.adapter = adapter
    }

    private fun processInput(it: String) {
        if (StringUtils.isBlank(it)) {
            return
        } else if (it == DELETE_CODE) {
            if (inputPins.size > 0) {
                inputPins.removeAt(inputPins.lastIndex)
            }
        } else {
            if (inputPins.size < CODE_LENGTH) {
                inputPins.add(it)
            }
        }

        if (inputPins.size >= CODE_LENGTH) {
            if (type == Type.Input) {
                if (Prefs.pin == inputPins.joinToString("")) {
                    setResult(RESULT_OK)
                    finish()
                } else {
                    Toast.makeText(this, "Wrong pin code !", Toast.LENGTH_SHORT).show()
                    reset()
                }
            } else {
                if (confirmMode) {
                    if (needConfirmPins == inputPins.joinToString("")) {
                        Prefs.pin = inputPins.joinToString("")
                        Toast.makeText(this, "Pin registered !", Toast.LENGTH_SHORT).show()
                        setResult(RESULT_OK)
                        finish()
                    } else {
                        Toast.makeText(this, "Not Matched pin code !", Toast.LENGTH_SHORT).show()
                        needConfirmPins = ""
                        confirmMode = false
                        reset()
                    }
                } else {
                    Toast.makeText(this, "Confirm pin code !", Toast.LENGTH_SHORT).show()
                    needConfirmPins = inputPins.joinToString("")
                    confirmMode = true
                    reset()
                }
            }
        }

        fillPinImages()
    }

    private fun fillPinImages() {
        pinImages.forEach {
            if (inputPins.size > pinImages.indexOf(it)) {
                it.setBackgroundResource(R.drawable.drawable_pin_fill)
            } else {
                it.setBackgroundResource(R.drawable.drawable_pin_unfill)
            }
        }
    }

    private fun reset() {
        if (type == Type.Input) {
            binding.guide.text = getString(R.string.enter_a_pin_number)
        } else if (confirmMode) {
            binding.guide.text = getString(R.string.confirm_a_pin_number)
        } else {
            binding.guide.text = getString(R.string.register_a_pin_number)
        }
        inputPins.clear()
        shufflePinCode()
    }

    private fun shufflePinCode() {
        val numbers = (0..9).toList().map { "$it" }.shuffled().toMutableList()
        numbers.add(9, String.Empty)
        numbers.add(DELETE_CODE)
        adapter.numbers = numbers
        adapter.notifyDataSetChanged()
    }
}
