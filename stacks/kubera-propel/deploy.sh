#!/bin/sh

set -e

################################################################################
# repo
################################################################################
helm repo add kubera https://charts.mayadata.io/
helm repo update > /dev/null
helm install kubera kubera/kubera-enterprise -n kubera
################################################################################
# chart
################################################################################
STACK="kubera"
CHART="kubera/kubera-enterprise"
CHART_VERSION="0.0.1"
NAMESPACE="kubera"

if [ -z "${MP_KUBERNETES}" ]; then
  # use local version of values.yml
  ROOT_DIR=$(git rev-parse --show-toplevel)
  values="$ROOT_DIR/stacks/kubera-propel/values.yml"
else
  # use github hosted master version of values.yml
  values="https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/kubera-propel/values.yml"
fi

helm upgrade "$STACK" "$CHART" \
  --atomic \
  --create-namespace \
  --install \
  --namespace "$NAMESPACE" \
  --values "$values" \
  --version "$CHART_VERSION"
