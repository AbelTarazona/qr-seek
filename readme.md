# Seek Challenge

Una aplicación móvil desarrollada en Flutter con integración nativa de Android, que permite escanear códigos QR y autenticarse mediante biometría (huella digital o reconocimiento facial).

## Características

- **Arquitectura Limpia**: Implementación de Clean Architecture con separación de capas (presentación, dominio y datos).
- **Escaneo de Códigos QR**: Procesamiento nativo en Android usando CameraX API y MLKit para optimizar rendimiento.
- **Autenticación Biométrica**: Soporte para huella digital y reconocimiento facial con BiometricPrompt API.
- **PIN de Respaldo**: Autenticación alternativa mediante PIN cuando la biometría falla.
- **Almacenamiento Seguro**: Uso de EncryptedSharedPreferences para almacenamiento seguro de credenciales.
- **Base de Datos Local**: Almacenamiento de escaneos en SQLite para consulta e historial.
- **Integración Nativa**: Módulos nativos de Android integrados mediante Pigeon y MethodChannels.
- **Gestión de Estado Avanzada**: Uso de BLoC para Flutter y Flow para Kotlin.
- **Pruebas Unitarias**: Cobertura de pruebas para componentes clave.

## Requisitos

- Flutter SDK: ^3.0.0
- Kotlin: ^1.8.0
- Dispositivo Android: API 21+ (Android 5.0 Lollipop o superior)
- Soporte para autenticación biométrica (opcional)

## Configuración del Proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/AbelTarazona/seek_challenge.git
cd seek_challenge
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Generar código Pigeon

```bash
dart run pigeon --input pigeon/pigeon.dart
```

### 4. Ejecutar la aplicación

```bash
flutter run
```

## Estructura del Proyecto

La aplicación sigue la arquitectura limpia (Clean Architecture) con la siguiente estructura:

- **lib/core/**: Componentes y utilidades centrales.
- **lib/data/**: Implementaciones de fuentes de datos y repositorios.
- **lib/domain/**: Entidades, casos de uso e interfaces de repositorios.
- **lib/presentation/**: UI, Widgets y BLoCs.
- **lib/di/**: Inyección de dependencias.
- **pigeon/**: Interfaces para la comunicación nativa.
- **android/**: Código nativo de Android y módulos Kotlin.

## Integración Nativa

### Módulo de Escaneo QR

El escaneo de códigos QR se implementa con integración nativa de Android:

- `QRScannerModule.kt`: Módulo nativo que utiliza CameraX API y MLKit.
- Procesamiento optimizado y bajo consumo de recursos.
- Comunicación bidireccional con Flutter mediante Pigeon.

### Módulo de Autenticación Biométrica

La autenticación biométrica se implementa con:

- `BiometricAuthModule.kt`: Módulo nativo que utiliza BiometricPrompt API.
- Soporte para huella digital y reconocimiento facial.
- Almacenamiento seguro de credenciales con EncryptedSharedPreferences.

## Compilación y Despliegue

### Generar APK

```bash
flutter build apk --release
```

El APK generado se encontrará en:
`build/app/outputs/flutter-apk/app-release.apk`

### Instalar en dispositivo

```bash
flutter install
```

## Pruebas

### Ejecutar pruebas unitarias

```bash
flutter test
```

## Consideraciones

- La aplicación requiere permisos de cámara para el escaneo de códigos QR.
- El acceso biométrico requiere hardware compatible.
- El PIN de respaldo se almacena de forma segura en EncryptedSharedPreferences.


