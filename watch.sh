#!/bin/sh

while true
do
	inotifywait -e modify Rapport.md
	./compile.sh
done
