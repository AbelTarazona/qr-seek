package com.example.seek_challenge

import android.app.Activity
import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.plugin.common.BinaryMessenger
import java.security.Signature
import java.util.concurrent.Executor

class BiometricAuthModule(private val activity: Activity, messenger: BinaryMessenger) :
    BiometricAuthApi {
    private lateinit var executor: Executor
    private lateinit var biometricPrompt: BiometricPrompt
    private lateinit var promptInfo: BiometricPrompt.PromptInfo
    private lateinit var encryptedSharedPreferences: EncryptedSharedPreferences

    init {
        BiometricAuthApi.setUp(messenger, this)
        setupBiometricAuth()
        setupEncryptedSharedPreferences()
    }

    private fun setupEncryptedSharedPreferences() {
        // Crear una clave maestra para EncryptedSharedPreferences
        val masterKey = MasterKey.Builder(activity)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        // Inicializar EncryptedSharedPreferences
        encryptedSharedPreferences = EncryptedSharedPreferences.create(
            activity,
            "secure_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        ) as EncryptedSharedPreferences
    }

    private fun setupBiometricAuth() {
        executor = ContextCompat.getMainExecutor(activity)

//        biometricPrompt = BiometricPrompt(this.activity, executor,
//            object : BiometricPrompt.AuthenticationCallback() {
//                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
//                    super.onAuthenticationError(errorCode, errString)
//                    // No hacer nada aquí, el resultado se gestiona en authenticateWithBiometrics()
//                }
//
//                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
//                    super.onAuthenticationSucceeded(result)
//                    // No hacer nada aquí, el resultado se gestiona en authenticateWithBiometrics()
//                }
//
//                override fun onAuthenticationFailed() {
//                    super.onAuthenticationFailed()
//                    // No hacer nada aquí, el resultado se gestiona en authenticateWithBiometrics()
//                }
//            })

        promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Autenticación Biométrica")
            .setSubtitle("Autentícate utilizando tu biometría")
            .setNegativeButtonText("Usar PIN")
            .build()
    }

    // Guardar PIN cifrado
    fun saveEncryptedPin(pin: String) {
        encryptedSharedPreferences.edit().putString("backup_pin", pin).apply()
    }

    // Verificar PIN
    fun verifyPin(pin: String): Boolean {
        val savedPin = encryptedSharedPreferences.getString("backup_pin", null)
        return savedPin == pin
    }

    private class BiometricResultCallback {
        private var result: BiometricAuthResult? = null
        private val lock = Object()

        fun onResult(authResult: BiometricAuthResult) {
            synchronized(lock) {
                result = authResult
                lock.notify()
            }
        }

        fun waitForResult(): BiometricAuthResult {
            synchronized(lock) {
                if (result == null) {
                    try {
                        lock.wait(10000) // Esperar hasta 10 segundos
                    } catch (e: InterruptedException) {
                        e.printStackTrace()
                    }
                }

                return result ?: BiometricAuthResult().copy(
                    success = false,
                    errorCode = "TIMEOUT",
                    errorMessage = "La operación expiró",
                )
            }
        }
    }

    override fun authenticateWithBiometrics(callback: (Result<BiometricAuthResult>) -> Unit) {
        val resultCallback = BiometricResultCallback()

        activity.runOnUiThread {
            biometricPrompt.authenticate(
                promptInfo,
                BiometricPrompt.CryptoObject(Signature.getInstance("SHA256withRSA"))
            )
        }

        callback(Result.success(resultCallback.waitForResult()))
    }

    override fun isBiometricAvailable(callback: (Result<Boolean>) -> Unit) {
        val biometricManager = BiometricManager.from(activity)
        val canAuthenticate =
            biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)
        callback(Result.success(canAuthenticate == BiometricManager.BIOMETRIC_SUCCESS))
    }
}