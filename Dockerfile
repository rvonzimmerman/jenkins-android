FROM jenkinsci/blueocean
env PATH="$PATH:/sdk/tools/bin"
env ANDROID_HOME="/sdk"
ENV SDK_TOOLS "3859397"
ENV BUILD_TOOLS "26.0.3"
ENV TARGET_SDK "26"
ENV GLIBC_VERSION "2.27-r0"
ADD  https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip /


USER root
RUN apk update && \
    apk add --no-cache --virtual=.build-dependencies wget unzip ca-certificates bash && \
	wget https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub && \
	wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O /tmp/glibc.apk && \
	wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O /tmp/glibc-bin.apk && \
	apk add --no-cache /tmp/glibc.apk /tmp/glibc-bin.apk && \
    apk add unzip && \
    unzip sdk-tools-*.zip -d /sdk && \
    chmod u+x sdk/tools/bin/* && \
    chown -R jenkins /sdk && \
	rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*



USER jenkins
RUN yes | sdkmanager --licenses && \
    sdkmanager "--update" && \ 
    sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"



