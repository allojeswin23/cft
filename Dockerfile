FROM ruby:2.7.8-alpine as rails

# Install general packages
#ENV PACKAGES build-base postgresql-dev gnupg make bash libpq netcat-openbsd git python3-dev python3 py3-pip openssh jq libxrender wkhtmltopdf
ENV PACKAGES build-base postgresql-dev gnupg make bash libpq netcat-openbsd git python3-dev python3 py3-pip openssh jq libxrender
RUN echo "Updating repos..." && apk update > /dev/null && \
    echo "Installing packages: ${PACKAGES}..." && apk add --no-cache $PACKAGES > /dev/null
    
# Install dependencies for wkhtmltopdf
#RUN apk add --update --no-cache --wait 10 libstdc++ libx11 libxrender libxext libssl1.1 ca-certificates fontconfig freetype ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family \
    #&& apk add --update --no-cache --virtual .build-deps msttcorefonts-installer \
    #&& update-ms-fonts \
    #&& fc-cache -f \
    #&& rm -rf /tmp/* \
    #&& apk del .build-deps
# Installing nodejs and aws-cli
ENV PG_PACKAGES postgresql postgis nodejs npm aws-cli
RUN echo "Updating repos..." && apk update --no-cache > /dev/null && \
    echo "Installing ${PG_PACKAGES}..." && apk add --no-cache $PG_PACKAGES > /dev/null

# Install YARN
RUN npm install -g yarn
