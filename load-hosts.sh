#!/bin/bash

set -a
source ".env"
set +a


conjur policy update -b data/$APP_GROUP -f <(envsubst < jenkins-hosts.yml)

conjur policy update -b data/vault -f <(envsubst < jenkins-hosts-grants.yml)
