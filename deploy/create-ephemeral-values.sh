#!/bin/bash

set -euo pipefail

namespace="$1"

if [ -z "$namespace" ]; then
    echo "Usage: create-ephemeral-values.sh <namespace>"
    exit 1
fi

cat << EOF > deploy/ephemeral/${namespace}.values.yml
ingress:
  enabled: false
  annotations:
    kubernetes.io/ingress.class: nginx-ingress
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    certmanager.k8s.io/cluster-issuer: letsencrypt-prod
    certmanager.k8s.io/acme-challenge-type: dns01
    certmanager.k8s.io/acme-dns01-provider: route53
  paths:
    - /
  hosts:
    - host: ${namespace}.bb-complete.hillghost.com
      paths: ["/"]
  tls:
    - secretName: taco-tuesday-cert
      hosts:
        - ${namespace}.bb-complete.hillghost.com
EOF