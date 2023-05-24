FROM buildpack-deps:bullseye

LABEL maintainer="Charles Harris <charles.harris.de@gmail.com>"

# Versions of Nginx and nginx-rtmp-module to use
ENV NGINX_VERSION nginx-1.17.3

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev certbot python3-certbot-nginx

# Download and decompress Nginx
RUN wget -O ${NGINX_VERSION}.tar.gz https://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxf ${NGINX_VERSION}.tar.gz

# Download and decompress RTMP module
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git

# Build and install Nginx
# The default puts everything under /usr/local/nginx, so it's needed to change
# it explicitly. Not just for order but to have it in the PATH
RUN cd ${NGINX_VERSION} && \
    ./configure \
        --with-http_ssl_module \
        --add-module=../nginx-rtmp-module && \
    make  && \
    make install

# Create /nginx/hls folders to hold .m3u8 snippets
RUN mkdir /nginx && \
    mkdir /nginx/hls

RUN chown -R www-data:www-data /nginx

# Overwrite default config file
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 1935 80
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]