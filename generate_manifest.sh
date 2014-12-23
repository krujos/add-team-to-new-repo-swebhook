#!/bin/sh

cat <<EOF > manifest.yml
applications:
- name: ps-at-e-webhook
  memory: 128M

  env:
     GITHUB_SECRET: $GITHUB_SECRET
     GITHUB_ACCESS_TOKEN: $GITHUB_ACCESS_TOKEN
     GITHUB_COLLABORATOR: $GITHUB_COLLABORATOR
EOF