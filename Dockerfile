FROM node:lts-stretch-slim
ENV NAME eval-env
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir -p /usr/share/man/man1
RUN echo deb http://cran.rstudio.com/bin/linux/debian stretch-cran34/ >> /etc/apt/sources.list
RUN echo deb http://deb.debian.org/debian stretch-backports main >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils wget curl
RUN apt-get install -y --no-install-recommends python python3
RUN apt-get install -y --no-install-recommends perl ruby
RUN apt-get install -y --no-install-recommends php-cli
RUN apt-get install -y --no-install-recommends lua5.3
RUN apt-get install -y --no-install-recommends --allow-unauthenticated r-base
RUN apt-get install -y --no-install-recommends gcc g++
RUN apt-get install -y --no-install-recommends gccgo
RUN apt-get install -y --no-install-recommends gobjc gnustep gnustep-devel
RUN apt-get install -y --no-install-recommends mono-mcs
RUN apt-get install -y --no-install-recommends fsharp
RUN apt-get install -y --no-install-recommends rustc
RUN apt-get install -y --no-install-recommends openjdk-11-jre-headless
RUN apt-get install -y --no-install-recommends openjdk-11-jdk-headless
RUN apt-get install -y sudo
RUN apt-get clean
WORKDIR /var/eval/
COPY ./package*.json /var/eval/
RUN npm install
EXPOSE 12345
RUN useradd -ms /bin/bash eval
CMD ["npm", "start"]
