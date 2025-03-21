package com.example.seek_challenge

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger

class BiometricAuthModule(private val activity: Activity, messenger: BinaryMessenger) :
    BiometricAuthApi {
    override fun authenticateWithBiometrics(callback: (Result<BiometricAuthResult>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun isBiometricAvailable(callback: (Result<Boolean>) -> Unit) {
        TODO("Not yet implemented")
    }
}