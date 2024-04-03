#!/bin/sh
set -e

# Set up iptables for transparent proxy
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8080

# Run the command passed to docker run
exec "$@"
