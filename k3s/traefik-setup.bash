#!/usr/bin/env bash
read -spr "hostname for traefik: " rules_host

cat >traefik-ingress.yaml <<EOF
---
apiVersion: networking.k8s.io/v1
kind: Ingress
  metadata:
  name: traefik-dashboard
  namespace: kube-system
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
    - host: ${rules_host}
      http:
      paths:
        - path: /
          pathType: Prefix
          backend:
          service:
            name: traefik
            port:
            number: 80
EOF
