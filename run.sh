sed -i -e "s/\%ES_HOST\%/$ELASTICSEARCH_HOST/" /etc/td-agent/td-agent.conf
/usr/sbin/td-agent -qq "$@"
