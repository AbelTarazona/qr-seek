package com.example.seek_challenge

import android.app.Activity
import android.content.Context
import android.view.Surface
import androidx.annotation.OptIn
import androidx.camera.core.CameraSelector
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.google.mlkit.vision.barcode.BarcodeScanner
import com.google.mlkit.vision.barcode.BarcodeScannerOptions
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.barcode.common.Barcode
import com.google.mlkit.vision.common.InputImage
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.view.TextureRegistry
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class QRScannerModule(private val activity: Activity, private val messenger: BinaryMessenger) :
    QRScannerApi {
    private var cameraExecutor: ExecutorService? = null
    private var cameraProvider: ProcessCameraProvider? = null
    private lateinit var qrScannerFlutterApi: QRScannerFlutterApi
    private var isScanning = false
    private var flutterTexture: TextureRegistry.SurfaceTextureEntry? = null
    private var previewSurface: Surface? = null
    private var cameraPreview: Preview? = null

    init {
        QRScannerApi.setUp(messenger, this)
        qrScannerFlutterApi = QRScannerFlutterApi(messenger)
    }

    override fun startScanner() {
        if (isScanning) return
        isScanning = true

        cameraExecutor = Executors.newSingleThreadExecutor()
        val cameraProviderFuture = ProcessCameraProvider.getInstance(activity)

        cameraProviderFuture.addListener({
            try {
                cameraProvider = cameraProviderFuture.get()
                if (flutterTexture != null) {
                    activity.runOnUiThread {
                        bindCameraUseCases()
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }, ContextCompat.getMainExecutor(activity))
    }

    override fun stopScanner() {
        isScanning = false
        cameraProvider?.unbindAll()
        cameraExecutor?.shutdown()
        try {
            if (cameraExecutor?.awaitTermination(1000, TimeUnit.MILLISECONDS) == false) {
                cameraExecutor?.shutdownNow()
            }
        } catch (e: InterruptedException) {
            cameraExecutor?.shutdownNow()
        }
    }

    override fun getCameraTexture(callback: (Result<CameraTextureResult>) -> Unit) {
        var result = CameraTextureResult()

        try {
            // Conseguir el TextureRegistry del FlutterEngine
            val flutterEngine = FlutterEngine(activity)

            // Crear una nueva entrada de textura
            flutterTexture = flutterEngine.renderer.createSurfaceTexture()
            val surfaceTexture = flutterTexture?.surfaceTexture()

            // Configurar el tamaño de la superficie
            surfaceTexture?.setDefaultBufferSize(1280, 720)

            // Crear una nueva superficie para la cámara
            previewSurface = Surface(surfaceTexture)

            // Devolver el ID de la textura y las dimensiones

            result = result.copy(
                textureId = flutterTexture?.id(),
                width = 1280.0,
                height = 720.0
            )

            // Si ya tenemos el proveedor de cámara, vincular los usos de la cámara
            if (isScanning && cameraProvider != null) {
                activity.runOnUiThread {
                    bindCameraUseCases()
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            callback(Result.failure(e))
        }

        callback(Result.success(result))
    }

    override fun disposeCameraTexture() {
        previewSurface?.release()
        previewSurface = null
        flutterTexture?.release()
        flutterTexture = null
    }

    private fun bindCameraUseCases() {
        val cameraProvider = cameraProvider ?: return
        val surface = previewSurface ?: return
        val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

        try {
            cameraProvider.unbindAll()

            // Configurar el preview
            cameraPreview =
                Preview.Builder().setTargetRotation(activity.windowManager.defaultDisplay.rotation)
                    .setTargetResolution(android.util.Size(1280, 720)).build()

            // Configurar un proveedor de superficie específico
            val surfaceProvider = Preview.SurfaceProvider { request ->
                // Asegurarse de que la superficie se actualice correctamente
                surface.release()

                val surfaceTexture = flutterTexture?.surfaceTexture()
                surfaceTexture?.setDefaultBufferSize(
                    request.resolution.width,
                    request.resolution.height
                )

                val newSurface = Surface(surfaceTexture)
                previewSurface = newSurface

                val executor = ContextCompat.getMainExecutor(activity)
                request.provideSurface(newSurface, executor) {
                    // Este callback se llama cuando la superficie es liberada
                    //it.run()
                }
            }

            // Asignar el proveedor de superficie a la vista previa
            cameraPreview?.setSurfaceProvider(surfaceProvider)

            // Configurar el analizador de códigos QR
            val imageAnalysis = ImageAnalysis.Builder()
                .setTargetResolution(android.util.Size(1280, 720))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setTargetRotation(activity.windowManager.defaultDisplay.rotation)
                .build()

            imageAnalysis.setAnalyzer(cameraExecutor!!, QRCodeAnalyzer { qrContent, format ->
                activity.runOnUiThread {
                    val result = QRScanResult().copy(
                        content = qrContent,
                        format = format,
                        timestamp = System.currentTimeMillis().toString()
                    )
                    qrScannerFlutterApi.onQRCodeDetected(result) {}
                }
            })

            // Vincular los casos de uso a la cámara
            cameraProvider.bindToLifecycle(
                activity as LifecycleOwner,
                cameraSelector,
                cameraPreview,
                imageAnalysis
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private class QRCodeAnalyzer(private val onQRCodeDetected: (String, String) -> Unit) :
        ImageAnalysis.Analyzer {
        private val options = BarcodeScannerOptions.Builder()
            .setBarcodeFormats(Barcode.FORMAT_QR_CODE)
            .build()
        private val scanner: BarcodeScanner = BarcodeScanning.getClient(options)

        @OptIn(ExperimentalGetImage::class)
        override fun analyze(imageProxy: ImageProxy) {
            val mediaImage = imageProxy.image
            if (mediaImage != null) {
                val image =
                    InputImage.fromMediaImage(mediaImage, imageProxy.imageInfo.rotationDegrees)

                scanner.process(image)
                    .addOnSuccessListener { barcodes ->
                        if (barcodes.isNotEmpty()) {
                            val barcode = barcodes[0]
                            barcode.rawValue?.let { value ->
                                val format = when (barcode.format) {
                                    Barcode.FORMAT_QR_CODE -> "QR_CODE"
                                    else -> "UNKNOWN"
                                }
                                onQRCodeDetected(value, format)
                            }
                        }
                    }
                    .addOnCompleteListener {
                        imageProxy.close()
                    }
            } else {
                imageProxy.close()
            }
        }
    }
}