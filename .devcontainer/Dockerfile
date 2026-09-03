# Devcontainer für KickbaseKumpel
#
# Hinweis: Das frühere Image "mcr.microsoft.com/devcontainers/flutter:3.9"
# existiert nicht mehr (deshalb schlug der Codespace-Build mit
# "No manifest found" / "docker pull" fehl). Stattdessen basiert dieses Image
# auf dem offiziellen Devcontainer-Base-Image und installiert Flutter direkt
# aus dem offiziellen Release-Archiv – mit Versionsauflösung und sha256-Prüfung
# über das offizielle Flutter-Releases-JSON (gleiches Muster wie in
# ios/ci_scripts/ci_post_clone.sh und wie subosito/flutter-action in der CI).
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Flutter-Version: identisch zur CI (.github/workflows → flutter-version "3.38.x")
ARG FLUTTER_VERSION=3.38.x
ARG FLUTTER_CHANNEL=stable

ENV FLUTTER_ROOT=/usr/local/flutter
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}"

# Systempakete für Flutter (Web + Linux-Desktop-Toolchain, lt. flutter.dev-Doku)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        clang \
        cmake \
        curl \
        libglu1-mesa \
        libgtk-3-dev \
        liblzma-dev \
        libstdc++-12-dev \
        ninja-build \
        pkg-config \
        python3 \
        unzip \
        xz-utils \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Release-Resolver: löst FLUTTER_VERSION (exakt oder Wildcard wie "3.38.x")
# auf die passende Archive-URL + sha256 aus dem offiziellen Releases-JSON auf.
COPY flutter-resolve.py /tmp/flutter-resolve.py

RUN set -eux; \
    curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json" \
        -o /tmp/releases.json; \
    RESOLVED="$(RELEASES_JSON=/tmp/releases.json \
        FLUTTER_VERSION=${FLUTTER_VERSION} \
        FLUTTER_CHANNEL=${FLUTTER_CHANNEL} \
        python3 /tmp/flutter-resolve.py)"; \
    FLUTTER_URL="${RESOLVED%% *}"; \
    FLUTTER_SHA256="${RESOLVED##* }"; \
    curl -fsSL "${FLUTTER_URL}" -o /tmp/flutter.tar.xz; \
    echo "${FLUTTER_SHA256}  /tmp/flutter.tar.xz" | sha256sum -c -; \
    tar -xJf /tmp/flutter.tar.xz -C /usr/local; \
    rm -f /tmp/flutter.tar.xz /tmp/releases.json /tmp/flutter-resolve.py; \
    # Flutter-SDK gehört dem Container-User, damit der Cache beschreibbar ist \
    chown -R vscode:vscode /usr/local/flutter; \
    # "dubious ownership"-Warnung des Git-SDK-Checks vermeiden \
    git config --system --add safe.directory "${FLUTTER_ROOT}"; \
    flutter --version

USER vscode

# Analytics deaktivieren, Targets aktivieren und Web-Artefakte vorab cachen
# (die App wird im Codespace typischerweise für Web gebaut, Port 8080)
RUN flutter config --no-analytics --enable-web --enable-linux-desktop \
    && flutter precache --web \
    && flutter doctor
