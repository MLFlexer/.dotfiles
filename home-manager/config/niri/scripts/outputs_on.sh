#!/usr/bin/env bash

# Get all output names
outputs=$(niri msg outputs | grep '^Output' | sed -E 's/.*\((.*)\)/\1/')

# Turn on each output
for output in $outputs; do
    niri msg output "$output" on
done
