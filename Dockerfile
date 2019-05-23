export JAVA_VERSION_MAJOR=8
export JAVA_VERSION_MINOR=212
export JAVA_VERSION_BUILD=04
export JAVA_PACKAGE=jdk
export JAVA_PACKAGE_VARIANT=nashorn
export JAVA_JCE=standard
export JAVA_HOME=/opt/jdk
export PATH=${PATH}:/opt/jdk/bin
export GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
export GLIBC_VERSION=2.29-r0
export LANG=C.UTF-8


RUN set -ex && \
    apk update && \
    apk -U upgrade && \
    apk add libstdc++ curl ca-certificates bash java-cacerts 
RUN for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done 
RUN apk add --allow-untrusted /tmp/*.apk 
RUN /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib
RUN wget https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u212-b04/jdk-8u212-ojdkbuild-linux-x64.zip
RUN mkdir -p /opt
RUN ln -s  /opt/jdk-8u212-ojdkbuild-linux-x64 /opt/jdk
RUN cd /opt
RUN unzip ../jdk-8u212-ojdkbuild-linux-x64.zip
RUN cd /
RUN rm -f jdk-8u212-ojdkbuild-linux-x64.zip
RUN rm -f /opt/jdk/src.zip

export JAVA_HOME=/opt/jdk
export PATH=$PATH:$JAVA_HOME
export PATH=/opt/jdk/bin:${PATH}
RUN echo "export JAVA_HOME=/opt/jdk" >> /etc/profile
