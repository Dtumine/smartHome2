#!/bin/bash

echo "Renombrando APK..."

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
NEW_NAME="build/app/outputs/flutter-apk/app-smart-homev1.apk"

if [ -f "$APK_PATH" ]; then
    cp "$APK_PATH" "$NEW_NAME"
    echo "APK renombrado exitosamente a: app-smart-homev1.apk"
    echo "Archivo disponible en: $NEW_NAME"
else
    echo "Error: No se encontró el archivo app-release.apk"
    echo "Asegúrate de haber ejecutado: flutter build apk --release"
    exit 1
fi

