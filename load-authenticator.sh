#!/bin/bash

set -a
source ".env"
set +a

# Create Jenkins Branch
conjur policy update -b data -f <(envsubst < jenkins-branch.yml)

#Load Jenkins authenticator policy
conjur policy update -b conjur/authn-jwt -f <(envsubst < authn-jwt-jenkins.yml)

#Enable the JWT Authenticator in Conjur Cloud
conjur authenticator enable --id authn-jwt/$CONJUR_AUTHENTICATOR_ID

#JWT configuration
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/audience -v $JENKINS_AUDIENCE
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/identity-path -v $JENKINS_IDENTITY
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/issuer -v $JENKINS_ISSUER
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/public-keys -v "{\"type\":\"jwks\", \"value\":$(curl  -k https://jenkins.demo.cybr:4000/jwtauth/conjur-jwk-set )}"
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/token-app-property -v $JENKINS_TOKEN_APP

