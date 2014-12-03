FROM ubuntu:14.04

# Ensure there are enough file descriptors for running Fluentd.
RUN ulimit -n 65536

# Install prerequisites.
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y -q libcurl4-openssl-dev make && \
    apt-get clean

# Install Fluentd.
RUN /usr/bin/curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

# Install the Elasticsearch Fluentd plug-in.
RUN /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch

# Copy the Fluentd configuration file.
COPY td-agent.conf /etc/td-agent/td-agent.conf

ADD run.sh /run.sh

# Always run the this setup script.
ENTRYPOINT ["/run.sh"]
