FROM ckan/ckan-dev:master
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /srv/app

RUN apt-get update -yqq \
    && apt-get install -y --no-install-recommends \
        curl \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y --no-install-recommends \
        nodejs \
        npm \
        gcc \
        supervisor \
        build-essential \
		git \
		libzip-dev \
        zip \
        unzip \
        wget \
        postgresql \
        libpq-dev \
        libpcre3 \
        libpcre3-dev \
        libmagic-dev \
        redis-server \
        nano \
        vim \
        sudo \
        systemd \
        sysvinit-utils \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libsqlite3-dev \
        libreadline-dev \
        libffi-dev \
        libbz2-dev \
    && npm install -g less \
    && npm install less \
    && wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz \
    && tar -xf Python-3.10.14.tgz \
    && cd Python-3.10.14 \
    && ./configure --enable-shared \
    && make -j 10 \
    && sudo make altinstall \
    && sudo ldconfig /usr/local/bin/python3.10 \
    && sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.10 1 \
    && sudo update-alternatives --config python3 \
    && sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.10 1 \
    && sudo update-alternatives --config python

# Supervisor
ADD docker/config/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD docker/config/supervisor/conf.d/*.conf /etc/supervisor/conf.d-available/

# PIP 3.10
RUN curl https://bootstrap.pypa.io/get-pip.py | sudo python3.10
RUN pip install supervisor

ADD docker/start.sh /usr/local/bin/start

# Create ckan user
RUN useradd ckan

# Create root directory
RUN mkdir -p /srv/app \
    && mkdir -p /etc/ckan
RUN chown -R ckan:ckan /srv/app \
    && chown -R ckan:ckan /etc/ckan \
    && chmod +x /usr/local/bin/start

ARG USER_ID
ARG GROUP_ID

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
        if [ $(getent passwd | grep ckan) ]; then \
            userdel -f ckan; fi &&\
        if [ $(getent group | grep ${GROUP_ID}) ]; then \
            groupmod -g ${GROUP_ID} -n ckan $(getent group ${GROUP_ID} | cut -d: -f1); else \
            groupadd -g ${GROUP_ID} ckan; fi &&\
        if [ $(getent passwd | grep ${USER_ID}) ]; then \
            usermod -l ckan -g ckan $(getent passwd ${USER_ID} | cut -d: -f1); else \
            useradd -l -u ${USER_ID} -g ckan ckan; fi && \
        install -d -m 0755 -o ckan -g ckan /srv/app && \
        chown --changes --silent --no-dereference --recursive --from=33:33 ${USER_ID}:${GROUP_ID} /srv/app && \
        echo 'alias ls="ls $LS_OPTIONS"\n\
        alias ll="ls $LS_OPTIONS -l"\n\
        alias l="ls $LS_OPTIONS -lA"\n\
        alias home="cd /srv/app"' >> /srv/app/.bashrc &&\
        chown ckan:ckan /srv/app/.bashrc \
;fi && chown ckan:ckan -R /etc/supervisor

RUN chown ckan:ckan -R /srv/app

CMD ["/usr/local/bin/start"]
