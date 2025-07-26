#!/usr/bin/env bash

if ! bluetoothctl show | grep -q "Powered: yes"; then
		bluetoothctl power on
fi
