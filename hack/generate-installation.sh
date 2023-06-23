#!/bin/bash

set -e

COMPONENT_NAME="github.tools.sap/cloud-orchestration-demo/laas-co-demo"
REPOSITORY_CONTEXT="o.ingress.ek-test.hubforplay.shoot.canary.k8s-hana.ondemand.com"

SCRIPT_PATH="$(dirname $0)"
SOURCE_PATH="$(dirname $0)/.."
VERSION=$(cat ${SOURCE_PATH}/VERSION)
COMMIT_SHA=$(git rev-parse HEAD)
EFFECTIVE_VERSION=${VERSION}-${COMMIT_SHA}

export COMPONENT_NAME
export REPOSITORY_CONTEXT
export EFFECTIVE_VERSION

cat ${SCRIPT_PATH}/installation-template.yaml | envsubst
