#!/bin/bash

ip netns exec host1 ip link set veth1 down
ip netns exec host2 ip link set veth2 down
ip netns exec nsra ip link set veth11 down
ip netns exec nsrb ip link set veth22 down

ip netns exec nsra ip link set vra down
ip netns exec nsrb ip link set vrb down
ip netns exec wan ip link set wan1 down
ip netns exec wan ip link set wan2 down


ip netns exec nsra ip link set gretap1 down
ip netns exec nsrb ip link set gretap1 down

ip netns exec nsra ip link set macsec1 down
ip netns exec nsrb ip link set macsec1 down
ip netns exec nsra ip link set br0 down
ip netns exec nsrb ip link set br0 down

ip netns exec nsra ip link del br0
ip netns exec nsrb ip link del br0
ip netns exec nsra ip link del macsec1
ip netns exec nsrb ip link del macsec1
ip netns exec nsra ip link del gretap1
ip netns exec nsrb ip link del gretap1

ip netns del host1
ip netns del host2
ip netns del nsra
ip netns del nsrb
ip netns del wan

echo 'Cleanup finished.'
