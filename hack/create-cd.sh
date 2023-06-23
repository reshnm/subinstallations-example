#!/bin/bash

set -e

MODE="dev"

while [[ $# -gt 0 ]]; do
  case $1 in
    -r|--release)
      MODE="release"
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

COMPONENT_NAME="github.com/reshnm/subinstallations-example"
REPOSITORY_CONTEXT="ghcr.io/reshnm/subinstallations-example"

SOURCE_PATH="$(dirname $0)/.."
VERSION=$(cat ${SOURCE_PATH}/VERSION)
COMMIT_SHA=$(git rev-parse HEAD)

if [[ "$MODE" == "release" ]]; then
    EFFECTIVE_VERSION=${VERSION%-*}
else
    echo $VERSION
    EFFECTIVE_VERSION=${VERSION}-${COMMIT_SHA}
fi

COMPONENT_ARCHIVE_PATH="$(mktemp -d)"

echo "> Generate Component Descriptor ${EFFECTIVE_VERSION}"
echo "> Creating base definition"
component-cli ca create "${COMPONENT_ARCHIVE_PATH}" \
    --component-name=${COMPONENT_NAME} \
    --component-version=${EFFECTIVE_VERSION} \
    --repo-ctx=${REPOSITORY_CONTEXT}

cp "${COMPONENT_ARCHIVE_PATH}/component-descriptor.yaml" "${SOURCE_PATH}/test/component-descriptor.yaml"

echo "> Adding resources"
component-cli ca resources add ${COMPONENT_ARCHIVE_PATH} \
    VERSION=${EFFECTIVE_VERSION} \
    ${SOURCE_PATH}/.landscaper/resources.yaml

echo "> Adding sources"
component-cli ca sources add ${COMPONENT_ARCHIVE_PATH} \
    VERSION=${EFFECTIVE_VERSION} \
    COMMIT_SHA=${COMMIT_SHA} \
    ${SOURCE_PATH}/.landscaper/sources.yaml

echo "> Creating component transport format"
COMPONENT_TRANSPORT_FORMAT_PATH=${COMPONENT_ARCHIVE_PATH}/ctf.tar
component-cli ctf add ${COMPONENT_TRANSPORT_FORMAT_PATH} -f ${COMPONENT_ARCHIVE_PATH}

echo "> Pushing conponent to repository context"
component-cli ctf push --repo-ctx=${REPOSITORY_CONTEXT} ${COMPONENT_TRANSPORT_FORMAT_PATH} 


echo "> Remote Component Descriptor"
component-cli ca remote get ${REPOSITORY_CONTEXT} ${COMPONENT_NAME} ${EFFECTIVE_VERSION}
