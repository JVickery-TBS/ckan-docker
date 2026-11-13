FROM opendatacanada/solr:9

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN /opt/solr/bin/solr stop -all

WORKDIR /srv/app

RUN apt-get update -yqq \
    && apt-get install -y --no-install-recommends \
      build-essential \
      zlib1g-dev \
      libssl-dev \
      libffi-dev \
    && wget https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz \
    && tar -xf Python-3.14.2.tgz \
    && cd Python-3.14.2 \
    && ./configure --enable-shared --enable-optimizations \
    && make -j 10 \
    && make altinstall \
    && ldconfig /usr/local/bin/python3.14 \
    && cd / \
    && rm -rf Python-3.14.2 Python-3.14.2.tgz \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.14 1 \
    && sudo update-alternatives --config python3 \
    && sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.14 1 \
    && sudo update-alternatives --config python

# PIP 3.14
RUN curl https://bootstrap.pypa.io/get-pip.py | sudo python3.14
RUN pip install supervisor

ARG USER_ID
ARG GROUP_ID

RUN if $(id -un ${USER_ID} >/dev/null 2>&1); then \
        userdel -f $(id -un ${USER_ID}); \
        if $(id -un solr >/dev/null 2>&1); then \
            usermod -u ${USER_ID} solr; \
        else \
            useradd -u ${USER_ID} solr; \
        fi \
    else \
        if $(id -un solr >/dev/null 2>&1); then \
            usermod -u ${USER_ID} solr; \
        else \
            useradd -u ${USER_ID} solr; \
        fi \
    fi \
    && \
    if [ $(getent group ${GROUP_ID}) ]; then \
        groupdel -f $(getent group ${GROUP_ID} | cut -d: -f1); \
        if [ $(getent group solr) ]; then \
            groupmod -g ${GROUP_ID} -n solr solr; \
        else \
            groupadd -g ${GROUP_ID} solr; \
        fi \
    else \
        if [ $(getent group solr) ]; then \
            groupmod -g ${GROUP_ID} -n solr solr; \
        else \
            groupadd -g ${GROUP_ID} solr; \
        fi \
    fi \
    && \
    chown solr:solr -R /var/solr

USER solr

CMD ["/usr/local/bin/start"]
