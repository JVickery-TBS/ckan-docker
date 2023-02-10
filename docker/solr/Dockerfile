FROM opendatacanada/solr

USER root

RUN /opt/solr/bin/solr stop -all

RUN chown solr:root -R /var/solr

USER solr

CMD ["/usr/local/bin/start", "-force"]
