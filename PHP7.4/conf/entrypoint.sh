#!/usr/bin/env bash

# brjupo - This file can be use to run commands when docker starts
# brjupo - This file DOES EXIST in common Debian Installation - /usr/local/bin/entrypoint.sh

# https://manpages.debian.org/testing/supervisor/supervisord.1.en.html

supervisord -n -c /etc/supervisord.conf
