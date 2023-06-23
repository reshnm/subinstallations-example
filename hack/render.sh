#!/bin/bash

TEST_DIR="$(dirname $0)/../test"
BLUEPRINT_DIR="$(dirname $0)/../.landscaper"

landscaper-cli blueprints render ${BLUEPRINT_DIR}/root \
    -c ${TEST_DIR}/component-descriptor.yaml \
    -f ${TEST_DIR}/values.yaml \
    -e ${TEST_DIR}/export-templates.yaml \
    -r ${BLUEPRINT_DIR}/resources.yaml
    