### KBase Logstash repo

This repo is used to build the logtash image used for pushing data into
the KBase elasticsearch instance

The docker image created by this repo accepts 3 environment variables:  
*listener_port* is the listener port for the TCP JSON listener  
*debug_output* is a flag, which if defined, will output the final JSON object generated to stdout  
*elastic_server* is a hostname:port where where there is an elasticsearch instance destination for logstash
