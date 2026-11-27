@rem Gradle wrapper script for Windows
@rem Android Studio regenerates this automatically on project open.
@if "%DEBUG%"=="" @echo off
@rem Check for gradle-wrapper.jar
if not exist "%~dp0\gradle\wrapper\gradle-wrapper.jar" (
    echo ERROR: gradle-wrapper.jar missing.
    echo Open this project in Android Studio to regenerate it automatically.
    exit /b 1
)
java -jar "%~dp0\gradle\wrapper\gradle-wrapper.jar" %*
