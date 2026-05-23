#!/bin/bash -x
for i in $(find . -name *.gd -or -name *.tscn); do
	sed -i "" "s/vfx\/fx\///g" $i
done
