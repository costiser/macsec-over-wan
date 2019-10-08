#!/bin/bash

set -e

modprobe macsec

ip netns add host1
ip netns add host2
ip link add veth1 type veth peer name veth11
ip link add veth2 type veth peer name veth22
ip link set veth1 netns host1
ip link set veth2 netns host2
ip netns exec host1 ip link set veth1 address 00:00:00:00:00:01
ip netns exec host1 ifconfig veth1 192.168.1.1/24 up
ip netns exec host2 ip link set veth2 address 00:00:00:00:00:02
ip netns exec host2 ifconfig veth2 192.168.1.2/24 up
echo 'Clients host1 and host2 created successfully...'
ip netns add nsra
ip netns add nsrb
ip link set veth11 netns nsra
ip link set veth22 netns nsrb

ip netns exec nsra ip link set veth11 up
ip netns exec nsrb ip link set veth22 up

ip link add vra type veth peer name wan1
ip link add vrb type veth peer name wan2
ip link set vra netns nsra
ip link set vrb netns nsrb
echo 'Linux routers nsra and nsrb created successfully...'

ip netns add wan
ip link set wan1 netns wan
ip link set wan2 netns wan
ip netns exec wan ip link set wan1 address 00:aa:aa:1f:1f:1f
ip netns exec wan ifconfig wan1 1.1.1.254/24 up
ip netns exec wan ip link set wan2 address 00:bb:bb:2f:2f:2f
ip netns exec wan ifconfig wan2 2.2.2.254/24 up
echo 'WAN created successfully...'
echo 'Enabling IP Forwarding in the WAN namespace:'
ip netns exec wan sysctl -w net.ipv4.ip_forward=1

ip netns exec nsra ip link set vra address 00:aa:aa:aa:aa:aa
ip netns exec nsra ifconfig vra 1.1.1.1/24 up
ip netns exec nsra ip route add default via 1.1.1.254

ip netns exec nsrb ip link set vrb address 00:bb:bb:bb:bb:bb
ip netns exec nsrb ifconfig vrb 2.2.2.2/24 up
ip netns exec nsrb ip route add default via 2.2.2.254


ip netns exec nsra ip link add gretap1 type gretap local 1.1.1.1 remote 2.2.2.2
ip netns exec nsrb ip link add gretap1 type gretap local 2.2.2.2 remote 1.1.1.1
ip netns exec nsra ip link set gretap1 address 00:00:00:11:11:11
ip netns exec nsra ip link set gretap1 up
ip netns exec nsrb ip link set gretap1 address 00:00:00:22:22:22
ip netns exec nsrb ip link set gretap1 up
echo 'GRETAP tunnel between the sites created successfully...'

ip netns exec nsra ip link add br0 type bridge
ip netns exec nsra ip link set veth11 master br0 
ip netns exec nsra ip link set gretap1 master br0
ip netns exec nsra ip link set br0 up

ip netns exec nsrb ip link add br0 type bridge
ip netns exec nsrb ip link set veth22 master br0 
ip netns exec nsrb ip link set gretap1 master br0
ip netns exec nsrb ip link set br0 up
echo 'Linux bridges created successfully...'

# MTU calculations for hosts
# Overhead:
# IP-external(20) + GRE(4) + L2(14) = 38
# MTU:  1500 - 38 = 1462
ip netns exec host1 ip link set veth1 mtu 1462
ip netns exec host2 ip link set veth2 mtu 1462
echo 'MTU set on hosts successfully...'

echo ''
echo 'Simulation started OK.'

