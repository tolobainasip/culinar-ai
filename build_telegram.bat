@echo off
echo Building Culinario for Telegram Mini Apps...

REM Build the Flutter web app
flutter build web --web-renderer canvaskit --release

REM Copy the telegram.html to the build directory
copy web\telegram.html build\web\

echo Build completed! The app is ready for deployment to Telegram Mini Apps.
