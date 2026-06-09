#!/bin/bash

if [ "${GODOT_BIN}" = "" ]; then
	echo ERROR: GODOT_BIN is not set to the path of the "godot" executable.
	exit -1
fi

DOC_DIR=doc_classes

echo Preparing...
rm -rf ${DOC_DIR}

echo Generating...
${GODOT_BIN} --doctool ./${DOC_DIR} --gdscript-docs .

TEST_FILES=$(find doc_classes -name "*test*" -or -name "NoFasterThan.xml")
echo Removing test classes: ${TEST_FILES}
for i in ${TEST_FILES}; do
	rm $i
done

echo Building Markdown...
python3 ./script/xml_to_md.py
