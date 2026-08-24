# 📱 Guía de Compilación de Android para RITMO

Este documento explica de forma detallada cómo compilar la aplicación **RITMO** para dispositivos Android (APK y App Bundle / AAB), tanto en entorno local como en CI/CD.

---

## 🛠️ Prerrequisitos

Antes de compilar la aplicación, asegúrate de contar con los siguientes elementos instalados en tu sistema:

1. **Flutter SDK**: Versión 3.24.0 o superior (`stable`).
2. **Dart SDK**: Incluido con Flutter.
3. **Java JDK**: JDK 17 (recomendado Zulu OpenJDK o Temurin).
4. **Android SDK & NDK**:
   - Android SDK Platform Tooling (`api-level 34`).
   - Licencias de Android SDK aceptadas (`flutter doctor --android-licenses`).

---

## 🚀 Compilación Local

### 1. Preparar las dependencias
Ejecuta el siguiente comando en la raíz del proyecto para descargar e instalar los paquetes:

```bash
flutter pub get
```

### 2. Generar el APK de Depuración (Debug APK)
Para probar la aplicación en un emulador o dispositivo físico en modo desarrollo:

```bash
flutter build apk --debug
```
📌 **Ubicación del archivo de salida**:
`build/app/outputs/flutter-apk/app-debug.apk`

---

### 3. Generar el APK de Producción (Release APK)
Para generar un APK optimizado listo para instalar en cualquier teléfono Android:

```bash
flutter build apk --release
```
📌 **Ubicación del archivo de salida**:
`build/app/outputs/flutter-apk/app-release.apk`

---

### 4. Generar Android App Bundle (AAB para Google Play)
Si planeas publicar la aplicación en Google Play Store:

```bash
flutter build appbundle --release
```
📌 **Ubicación del archivo de salida**:
`build/app/outputs/bundle/release/app-release.aab`

---

## 🔐 Configuración de Firma digital (Keystore) para Release

Para publicar en Google Play o instalar actualizaciones en producción, la app debe estar firmada:

1. Genera tu Keystore de producción:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Crea el archivo `android/key.properties`:
   ```properties
   storePassword=<tu-password>
   keyPassword=<tu-password>
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

---

## ⚡ Solución de Problemas Comunes

### Error: `LicenceNotAcceptedException`
Si la compilación falla indicando que las licencias de Android NDK/SDK no han sido aceptadas:
```bash
flutter doctor --android-licenses
```
Presiona `y` para aceptar todas las licencias del SDK.

### Error: `Java heap space` / Gradle memory limit
Si Gradle falla por memoria consumida, asegúrate de tener en `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m
```

---

## 🤖 Integración Continua (GitHub Actions)

El proyecto incluye un flujo de trabajo automatizado en `.github/workflows/dart.yml` que valida y compila el APK automáticamente en cada `push` a las ramas `main` o `master`.
