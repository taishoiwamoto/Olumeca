#!/bin/bash
set -e

rm -f /Olumeca/tmp/pids/server.pid

exec "$@"
