#!/bin/sh

while true
do
	inotifywait -e modify Annexes.md
	./compile_annexes.sh
done
