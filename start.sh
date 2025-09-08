#!/bin/bash

# start.sh - Startup Script für eas3-mqtt

echo "🚀 Starting eas3-mqtt gateway..."

# Environment Variables mit Defaults
EAS3_BROADCAST_PORT=${EAS3_BROADCAST_PORT:-45454}
MQTT_HOST=${MQTT_HOST:-mosquitto}
MQTT_PORT=${MQTT_PORT:-1883}
MQTT_USERNAME=${MQTT_USERNAME:-admin}
MQTT_PASSWORD=${MQTT_PASSWORD:-password}
MQTT_AUTODISCOVERY_FREQUENCY=${MQTT_AUTODISCOVERY_FREQUENCY:-10}
MQTT_AUTODISCOVERY_DISABLED=${MQTT_AUTODISCOVERY_DISABLED:-false}
EAS3_MQTT_DEVICE_PREFIX=${EAS3_MQTT_DEVICE_PREFIX:-eas3_}

# Debug Ausgabe
echo "Configuration:"
echo "  EAS3_BROADCAST_PORT: $EAS3_BROADCAST_PORT"
echo "  MQTT_HOST: $MQTT_HOST"
echo "  MQTT_PORT: $MQTT_PORT"
echo "  MQTT_USERNAME: $MQTT_USERNAME"
echo "  MQTT_AUTODISCOVERY_FREQUENCY: $MQTT_AUTODISCOVERY_FREQUENCY"
echo "  MQTT_AUTODISCOVERY_DISABLED: $MQTT_AUTODISCOVERY_DISABLED"
echo "  EAS3_MQTT_DEVICE_PREFIX: $EAS3_MQTT_DEVICE_PREFIX"

# Prüfe ob Python oder Node.js verwendet werden soll
if [ -f "package.json" ]; then
    echo "📦 Node.js application detected"
    # Node.js Start
    exec npm start
elif [ -f "eas3_mqtt.py" ]; then
    echo "🐍 Python application detected"
    # Python Start mit Parametern
    exec python -u eas3_mqtt.py \
        --broadcast-port "$EAS3_BROADCAST_PORT" \
        --mqtt-host "$MQTT_HOST" \
        --mqtt-port "$MQTT_PORT" \
        --mqtt-username "$MQTT_USERNAME" \
        --mqtt-password "$MQTT_PASSWORD" \
        --autodiscovery-frequency "$MQTT_AUTODISCOVERY_FREQUENCY" \
        --autodiscovery-disabled "$MQTT_AUTODISCOVERY_DISABLED" \
        --device-prefix "$EAS3_MQTT_DEVICE_PREFIX"
else
    echo "❌ ERROR: No application found (package.json or eas3_mqtt.py)"
    exit 1
fi