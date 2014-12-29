#!/bin/sh
if [ -z $APP_ROUTE ] ; then 
	APP_ROUTE=$APP_NAME
fi

cat <<EOF > manifest.yml
applications:
- name: $APP_NAME
  memory: 128M
  host: $APP_ROUTE

  env:
     GITHUB_SECRET: $GITHUB_SECRET
     GITHUB_ACCESS_TOKEN: $GITHUB_ACCESS_TOKEN
     GITHUB_COLLABORATOR: "$GITHUB_COLLABORATOR"
EOF
