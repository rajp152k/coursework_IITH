#! /bin/bash

sudo ip link add LBr1 type bridge
sudo ip link add LBr2 type bridge
sudo ip link add LBrA type bridge
sudo ip link add LBrB type bridge
sudo ip link add LBrC type bridge

sudo ip link set LBr1 up
sudo ip link set LBr2 up
sudo ip link set LBrA up
sudo ip link set LBrB up
sudo ip link set LBrC up
