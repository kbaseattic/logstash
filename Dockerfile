FROM kbase/docker-collectd:latest as collectd
FROM logstash:5.6
EXPOSE 9000

# Based on docs here:
# https://www.elastic.co/guide/en/logstash/current/docker-config.html

RUN logstash-plugin update logstash-input-udp && \
    rm -f /usr/share/logstash/pipeline/logstash.conf

USER root
RUN curl -o /tmp/dockerize.tgz https://raw.githubusercontent.com/kbase/dockerize/master/dockerize-linux-amd64-v0.6.1.tar.gz && \
    cd /usr/bin && \
    tar xvzf /tmp/dockerize.tgz && \
    mkdir -p /usr/share/logstash/config && \
    curl -o /usr/share/logstash/config/collectd-types.db https://raw.githubusercontent.com/collectd/collectd/master/src/types.db && \
    cd /tmp && \
    curl -o GeoLite2.tar.gz https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz && \
    curl -o GeoLite2-ASN.tar.gz https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz && \
    tar xvzf GeoLite2.tar.gz --strip-components=1 && \
    tar xvzf GeoLite2-ASN.tar.gz --strip-components=1 && \
    cp GeoLite2-City.mmdb GeoLite2-ASN.mmdb /usr/share/logstash/vendor/bundle/jruby/1.9/gems/logstash-filter-geoip-4.3.1-java/vendor && \
    rm *.txt *.mmdb
ADD .templates /usr/share/logstash/.templates/
ADD pipeline /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/
# Update the types.db to match the collectd we're using
COPY --from=collectd /usr/share/collectd/types.db /usr/share/logstash/vendor/bundle/jruby/1.9/gems/logstash-codec-collectd-3.0.8/vendor/types.db
RUN chown -R logstash:logstash /usr/share/logstash/pipeline

USER logstash
ENTRYPOINT [ "/usr/bin/dockerize"]
CMD ["-template", "/usr/share/logstash/.templates/10inputs.templ:/usr/share/logstash/pipeline/10inputs", \
     "-template", "/usr/share/logstash/.templates/99outputs.templ:/usr/share/logstash/pipeline/99outputs", \
     "logstash", "-f", "/usr/share/logstash/pipeline" ]
