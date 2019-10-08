# MACsec over WAN or Internet

MACsec is an interesting alternative to existing tunneling solutions, that protects Layer 2 by performing integrity, origin authentication and, optionally, encryption. Normal use-case is to use MACsec between hosts and access switches, between two hosts or between two switches.

This repository contains bash scripts that simulates a scenario where MACsec is used together with a Layer 2 GRE tunnel to protect the traffic between two remote sites, over WAN or Internet, like a site-to-site VPN  at Layer 2.

## Prerequisites

* you need a Linux machine
* you must run all scripts with `sudo` (since creating network namespaces and veth interfaces require root privileges)

## Instructions

Note that each `demo-setup-` script has a corresponding `demo-cleanup-` script that removes all the namespaces and veth interfaces used in that demo.

Follow the instructions in my [blog post about MACsec Over WAN](https://costiser.ro/2019/10/08/macsec-over-wan/).
