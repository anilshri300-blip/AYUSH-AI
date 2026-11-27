#!/bin/sh
# Gradle wrapper script for Unix
# Android Studio regenerates this automatically on project open.
# If running from CLI: gradle wrapper --gradle-version=8.6 to regenerate.

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'
GRADLE_USER_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}"
GRADLE_WRAPPER_JAR="$SCRIPT_DIR/gradle/wrapper/gradle-wrapper.jar"
GRADLE_WRAPPER_PROPERTIES="$SCRIPT_DIR/gradle/wrapper/gradle-wrapper.properties"

set -e

if [ ! -f "$GRADLE_WRAPPER_JAR" ]; then
  echo "ERROR: gradle-wrapper.jar missing."
  echo "Open this project in Android Studio — it will regenerate the wrapper automatically."
  echo "Or run: gradle wrapper --gradle-version=8.6"
  exit 1
fi

exec java $DEFAULT_JVM_OPTS -jar "$GRADLE_WRAPPER_JAR" "$@"
