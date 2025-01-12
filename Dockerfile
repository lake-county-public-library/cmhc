FROM ruby:2.7.2

MAINTAINER Andrew Woods <awoods01@gmail.com>

# Install apt dependencies
RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y software-properties-common
RUN apt-get install -y git
RUN apt-get install -y ghostscript
RUN apt-get install -y imagemagick
RUN apt-get install -y libvips
RUN apt-get install -y vim

# Add imagemagick PDF fix
RUN sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml

# Install locales
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN mkdir /app
COPY Gemfile* *.gemspec ./app
COPY policy.xml /etc/ImageMagick-6/policy.xml
WORKDIR /app

RUN useradd --create-home MARMOT+awoods
RUN groupadd MARMOT+domain
RUN usermod -G MARMOT+domain MARMOT+awoods

# Update permissions for the etdadm user and group
COPY change_id.sh /root/change_id.sh
RUN chmod 755 /root/change_id.sh && \
  /root/change_id.sh -u 2009348 -g 2000513

USER MARMOT+awoods

RUN bundle

EXPOSE 4000
