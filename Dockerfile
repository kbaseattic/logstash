FROM docker.elastic.co/logstash/logstash:6.1.2
EXPOSE 9000

# Based on docs here:
# https://www.elastic.co/guide/en/logstash/current/_configuring_logstash_for_docker.html

RUN logstash-plugin remove x-pack
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
ADD pipeline/ /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/
