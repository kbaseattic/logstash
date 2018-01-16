FROM docker.elastic.co/logstash/logstash:6.1.2
EXPOSE 9000

# Based on docs here:
# https://www.elastic.co/guide/en/logstash/current/_configuring_logstash_for_docker.html

RUN logstash-plugin remove x-pack
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
USER root
RUN curl -o /tmp/dockerize.tgz https://raw.githubusercontent.com/kbase/dockerize/dist/dockerize-linux-amd64-v0.5.0.tar.gz && \
    cd /usr/local/bin && \
    tar xvzf /tmp/dockerize.tgz
ADD .templates /usr/share/logstash/.templates/
ADD config/ /usr/share/logstash/config/

USER logstash
ENTRYPOINT [ "/usr/local/bin/dockerize"]
CMD ["-template", "/usr/share/logstash/.templates/10inputs.templ:/usr/share/logstash/pipeline/10inputs", \
     "-template", "/usr/share/logstash/.templates/99outputs.templ:/usr/share/logstash/pipeline/99outputs", \
     "logstash" ]