#! /bin/bash
chmod 666 /dev/bpf*
route -n add -net 192.168.0.0 -netmask 255.255.0.0 192.168.196.254
ifconfig en6 ether 44:8a:5b:f3:5f:49
echo "Done"