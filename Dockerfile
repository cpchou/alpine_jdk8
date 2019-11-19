# AlpineLinux with a glibc-2.29-r0 and Open Java 8
FROM alpine:3.8

# Java Version and other ENV
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=212 \
    JAVA_VERSION_BUILD=04 \
    JAVA_PACKAGE=jdk \
    JAVA_PACKAGE_VARIANT=nashorn \
    JAVA_JCE=standard \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.29-r0 \
    LANG=C.UTF-8 \
    TZ=Asia/Taipei


RUN set -ex && \
    apk update && \
    apk -U upgrade && \
    apk add libstdc++ curl ca-certificates bash java-cacerts 
RUN for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done 
RUN apk add --allow-untrusted /tmp/*.apk 
RUN /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib
RUN wget https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u212-b04/jdk-8u212-ojdkbuild-linux-x64.zip
RUN mkdir -p /opt
RUN ln -s  /jdk-8u212-ojdkbuild-linux-x64 /opt/jdk
RUN unzip ../jdk-8u212-ojdkbuild-linux-x64.zip
RUN rm -f jdk-8u212-ojdkbuild-linux-x64.zip
RUN rm -f /opt/jdk/src.zip

ENV JAVA_HOME=/opt/jdk \
    PATH=$PATH:$JAVA_HOME \
    PATH=/opt/jdk/bin:${PATH} 
	
RUN echo "export JAVA_HOME=/opt/jdk" >> /etc/profile

#RUN cd /opt/jdk/ && ln -s ./jre/bin ./bin 

RUN sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security
RUN apk del curl glibc-i18n
RUN rm -rf /opt/jdk/jre/plugin \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/bin/orbd \
           /opt/jdk/jre/bin/pack200 \
           /opt/jdk/jre/bin/policytool \
           /opt/jdk/jre/bin/rmid \
           /opt/jdk/jre/bin/rmiregistry \
           /opt/jdk/jre/bin/servertool \
           /opt/jdk/jre/bin/tnameserv \
           /opt/jdk/jre/bin/unpack200 \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/lib/oblique-fonts \
           /opt/jdk/jre/lib/plugin.jar \
           /tmp/* /var/cache/apk/* 
RUN ln -sf /etc/ssl/certs/java/cacerts $JAVA_HOME/jre/lib/security/cacerts
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
	
RUN apk add tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

#安裝字型
RUN apk --no-cache add msttcorefonts-installer fontconfig && update-ms-fonts && fc-cache -f
#全字庫正楷體
#RUN wget https://cpchou0701.diskstation.me/fonts/TW-Kai-98_1.ttf
#全字庫宋體
#RUN wget https://cpchou0701.diskstation.me/fonts/TW-Sung-98_1.ttf
#RUN mv *.ttf /usr/share/fonts/truetype
RUN fc-cache -f -v

RUN apk add busybox-extras
RUN apk --no-cache add curl
