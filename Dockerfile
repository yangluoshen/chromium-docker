# Run Chrome Headless in a container
#
# What was once a container using the experimental build of headless_shell from
# tip, this container now runs and exposes stable Chrome headless via 
# google-chome --headless.
#
# Usage:
# docker build -t xxx/chromium .
# docker run --rm -d -p 19222:19222 xxx/chromium
#
# Checkout if ok
# curl localhost:19222/json

FROM debian:sid
LABEL name="chrome-headless" \
			maintainer="yangluo <yangluoshen@gmail.com>" \
			description="Google Chrome Headless in a container"

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get -y install \
    libappindicator3-1 \
    libx11-xcb1 libx11-xcb-dev \
    libxtst6 \
    libasound2 \
    libnss3 \
    libxss-dev \
	apt-transport-https \
	ca-certificates \
	curl \
  gnupg \
	--no-install-recommends \
	&& apt-get update \
    && apt-get -y install ttf-wqy-microhei \
	&& apt-get clean

# Add Chrome as a user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

COPY assert/Linux_538757_chromium.tar.gz /tmp
RUN tar -zxf /tmp/Linux_538757_chromium.tar.gz -C /home/chrome
RUN chown -R chrome:chrome /home/chrome/chrome-linux
RUN cd /usr/local/bin/ && ln -s /home/chrome/chrome-linux/chrome chromium


# install emoji
COPY assert/NotoColorEmoji.tar.gz /tmp/
RUN chmod +x /tmp/NotoColorEmoji.tar.gz
RUN mkdir -p /root/.fonts
RUN tar -zxf /tmp/NotoColorEmoji.tar.gz -C /root/.fonts

# config font
RUN mkdir -p /root/.config/fontconfig/
COPY assert/fonts.conf /root/.config/fontconfig/
RUN fc-cache -f -v

# Run Chrome non-privileged
#USER chrome

EXPOSE 19222

# Autorun chrome headless with no GPU
ENTRYPOINT [ "chromium" ]
CMD [ "--headless","--no-sandbox", "--disable-namespace-sandbox", "--disable-setuid-sandbox", "--disable-gpu","google-chrome-stable", "--hide-scrollbars","--no-default-browser-check","--no-first-run", "--remote-debugging-address=0.0.0.0", "--remote-debugging-port=19222" ]
