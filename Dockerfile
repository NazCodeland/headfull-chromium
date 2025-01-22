FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=America/Los_Angeles

# === INSTALL SYSTEM DEPENDENCIES AND PYTHON ===
RUN apt-get update && \
    # Install common tools and Python build dependencies
    apt-get install -y curl wget gpg software-properties-common && \
    # Feature-parity tools
    apt-get install -y --no-install-recommends git openssh-client && \
    # Add Python PPA and install Python
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3.11-distutils && \
    # Set Python 3.11 as default
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    # Install pip and poetry
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    pip3 install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    # Create the pwuser (needed for playwright)
    adduser pwuser && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/*

# === INSTALL PLAYWRIGHT SYSTEM DEPENDENCIES ===
RUN apt-get update && \
    apt-get install -yq \
    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget \
    xvfb x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps libgbm-dev && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# === SET UP PLAYWRIGHT INFRASTRUCTURE ===
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Create playwright directory with proper permissions
RUN mkdir -p /ms-playwright && \
    chmod -R 777 /ms-playwright

# Copy VNC setup scripts
COPY ./entrypoint.sh /entrypoint.sh
COPY ./run_vnc.sh /run_vnc.sh
RUN chmod +x /entrypoint.sh /run_vnc.sh

# Set VNC password
ENV VNC_PASSWORD="mypassword"

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["run"]
