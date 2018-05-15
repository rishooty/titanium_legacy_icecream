# Set the base image
FROM bitnami/minideb

# Dockerfile author / maintainer
MAINTAINER Nicholas Ricciuti <rishooty@gmail.com>

# Silence stdin errors
ENV DEBIAN_FRONTEND noninteractive

# Add fixuid usergroup
RUN addgroup --gid 1000 docker && \
	adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker

# Update packages and add repositories
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y apt-utils && apt-get dist-upgrade -y && \
	apt-get install -y software-properties-common gnupg usbutils curl && \ 
	add-apt-repository -y "deb http://ppa.launchpad.net/webupd8team/java/ubuntu artful main" && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C2518248EEA14886 && \
	curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Install fixuid
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.3/fixuid-0.3-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

# Accept oracle java license agreement
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

# Install titanium dependencies and CLI
RUN apt-get install -y nodejs git build-essential oracle-java8-installer unzip libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 && \
	npm install -g npm@2.15.10 n && \
	n 0.12.18 && \
	npm install -g git://github.com/appcelerator/titanium.git#5.0.8 alloy@1.10.03

# Switch to default user and install titanium sdk
USER docker:docker
WORKDIR /home/docker
RUN titanium sdk install --branch 3_5_X

# Install SDK Tools 25
RUN wget -q http://dl-ssl.google.com/android/repository/tools_r25.2.5-linux.zip && \
	unzip tools_r25.2.5-linux.zip -d SDK && \
	rm -f tools_r25.2.5-linux.zip

# Install Android SDK 19 for SDK Tools 25
RUN mkdir /home/docker/.android
ADD insecure_shared_adbkey /root/.android/adbkey
ADD insecure_shared_adbkey.pub /root/.android/adbkey.pub
ADD insecure_shared_adbkey /home/docker/.android/adbkey
ADD insecure_shared_adbkey.pub /home/docker/.android/adbkey.pub
RUN touch /home/docker/.android/repositories.cfg && \
	mkdir -p SDK/licenses && echo -e "\nd56f5187479451eabf01fb78af6dfcb131a6481e" > "SDK/licenses/android-sdk-license" && \
	SDK/tools/bin/sdkmanager "platforms;android-19" "platform-tools" "build-tools;27.0.3"

# Configure Titanium for SDK Tools 25
RUN ti config android.sdkPath SDK

# Install and configure Titanium for NDK r10e
RUN wget -q https://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip && unzip android-ndk-r10e-linux-x86_64.zip -d NDK && rm -f android-ndk-r10e-linux-x86_64.zip && ti config android.ndkPath NDK/android-ndk-r10e

# Setup work environment
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENTRYPOINT ["fixuid"]
RUN mkdir Code
EXPOSE 5037
CMD ["/home/docker/SDK/platform-tools/adb", "-a", "-P", "5037", "server", "nodaemon"]
