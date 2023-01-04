FROM gcr.io/gae-runtimes/php81:php81_20221215_8_1_13_RC00

# Install necessary packages
RUN apt-get update -y \
&& apt-get install -y --no-install-recommends gcc apt-utils libjpeg-dev libpng-dev bsdl1.2-dev libtiff-dev libgif-dev

# Compile libwebp
RUN wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz \
&& tar xvzf libwebp-1.1.0.tar.gz \
&& cd libwebp-1.1.0 \
&& ./configure \
&& make \
&& make install \
&& cd ..

# Compile Imagemagick
RUN apt-get -y build-dep imagemagick \
&& wget https://imagemagick.org/download/ImageMagick.tar.gz \
&& tar xvzf ImageMagick.tar.gz \
&& cd ImageMagick-7* \
&& ./configure --with-webp=yes \
&& make \
&& make install \
&& ldconfig /usr/local/lib \
&& cd ..

# Install Imagemagick
RUN apt-get install -y -f php-imagick imagemagick libmagickwand-dev \
&& pecl install imagick -y

RUN php --ini && echo "extension=imagick.so" >> "/etc/php.ini"
