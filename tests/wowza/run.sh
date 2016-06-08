#!/bin/bash
cat tests/wowza/wowzamediaserver_access.log | logstash -w 1 -f tests/wowza/wowza-input.conf
