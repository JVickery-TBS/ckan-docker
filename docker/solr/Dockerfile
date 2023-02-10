FROM opendatacanada/solr

USER root

RUN /opt/solr/bin/solr stop -all

# Create root data directory
RUN mkdir -p /var/solr/data

# Set new files with correct user:group
RUN mkdir -p /var/solr/data && \
    chown -R solr:root /var/solr/data && \
    chmod +x /usr/local/bin/start

CMD ["/usr/local/bin/start"]
