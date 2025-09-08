FROM node:20-slim

WORKDIR /app

# System-Abhängigkeiten installieren (inkl. Git)
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

# GitHub Repository klonen
RUN git clone https://github.com/sr258/eas3-mqtt.git . \
    && git checkout v1.0.0

# Node.js Abhängigkeiten installieren
RUN if [ -f "package.json" ]; then npm install; fi

# Python Abhängigkeiten installieren
RUN if [ -f "requirements.txt" ]; then pip3 install --no-cache-dir -r requirements.txt; fi

# Build durchführen (falls TypeScript)
RUN if [ -f "tsconfig.json" ]; then npm run build; fi

# Start Script kopieren und ausführbar machen
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Healthcheck hinzufügen
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD netstat -an | grep :45454 > /dev/null || exit 1

CMD ["/start.sh"]