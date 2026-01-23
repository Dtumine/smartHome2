@echo off
echo Renombrando APK...

set APK_PATH=build\app\outputs\flutter-apk\app-release.apk
set NEW_NAME=build\app\outputs\flutter-apk\app-smart-homev1.apk

if exist "%APK_PATH%" (
    copy "%APK_PATH%" "%NEW_NAME%" >nul
    echo APK renombrado exitosamente a: app-smart-homev1.apk
    echo Archivo disponible en: %NEW_NAME%
) else (
    echo Error: No se encontro el archivo app-release.apk
    echo Asegurate de haber ejecutado: flutter build apk --release
)

pause

