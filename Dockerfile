FROM debian:bookworm-slim

LABEL description="SinusBot - TeamSpeak 3 and Discord music bot."
LABEL version="1.1f"

# Install dependencies and clean up afterwards
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        unzip \
        curl \
        python3 \
        procps \
        libxkbcommon0 \
        locales \
        x11vnc \
        xvfb \
        libxcursor1 \
        libnss3 \
        libegl1-mesa \
        libasound2 \
        libglib2.0-0 \
        libxcomposite-dev \
        less \
        jq \
        libevent-2.1-7 \
        libxcb-xinerama0 \
        liblcms2-2 \
        libatomic1 \
        libxcb-icccm4 \
        libxcb-keysyms1 \
        libxcb-randr0 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxcb-xkb1 \
        libxkbcommon-x11-0 \
        libpci3 \
        libxslt1.1 \
        libxcb-image0 && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

WORKDIR /opt/sinusbot

ADD install.sh .
RUN chmod 755 install.sh

# Download/Install SinusBot
RUN bash install.sh sinusbot

# Download/Install yt-dlp
RUN bash install.sh yt-dlp

# Download/Install deno
RUN bash install.sh deno

# Download/Install Text-to-Speech
RUN bash install.sh text-to-speech

# Download/Install TeamSpeak Client
RUN bash install.sh teamspeak

ADD entrypoint.sh .
RUN chmod 755 entrypoint.sh

EXPOSE 8087

VOLUME ["/opt/sinusbot/data", "/opt/sinusbot/scripts"]

ENTRYPOINT ["/opt/sinusbot/entrypoint.sh"]

HEALTHCHECK --interval=1m --timeout=10s \
  CMD curl --no-keepalive -f http://localhost:8087/api/v1/botId || exit 1
