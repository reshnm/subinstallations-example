REPO_ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: component
component:
	@$(REPO_ROOT)/hack/create-cd.sh

.PHONY: component-release
component-release:
	@$(REPO_ROOT)/hack/create-cd.sh -r

.PHONY: generate-installation
generate-installation:
	@$(REPO_ROOT)/hack/generate-installation.sh

.PHONY: render
render:
	@$(REPO_ROOT)/hack/render.sh | tee render.out

.PHONY: publish
publish: component

.PHONY: release
release: component-release
