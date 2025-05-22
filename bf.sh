#!/bin/bash

mapfile -t uids < array_uids.txt

for uid in "${uids[@]}"; do
	pm3 << EOF
hf mfu sim -t 7 --uid $uid
EOF
done
