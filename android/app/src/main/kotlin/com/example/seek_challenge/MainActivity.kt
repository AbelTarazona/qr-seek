package com.example.seek_challenge

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private lateinit var qrScannerModule: QRScannerModule
    private lateinit var biometricAuthModule: BiometricAuthModule

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        qrScannerModule = QRScannerModule(this, flutterEngine.dartExecutor.binaryMessenger)
        biometricAuthModule = BiometricAuthModule(this, flutterEngine.dartExecutor.binaryMessenger)
    }
}
