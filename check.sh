#!/bin/bash

INPUTS="tests/in/"
OUTPUTS="tests/out/"
REFS="tests/ref/"

IN_EXT=".in"
OUT_EXT=".out"
REF_EXT=".ref"

TASK_SCORE=4
MAX_SCORE=12
TOTAL=0

make > /dev/null 2>&1

echo "=============== AVX instructions =============="

for i in 1 2 3; do
	./checker < "${INPUTS}${i}${IN_EXT}" > "${OUTPUTS}${i}${OUT_EXT}"
	diff "${OUTPUTS}${i}${OUT_EXT}" "${REFS}${i}${REF_EXT}" > /dev/null
	if [[ $? == "0" ]]; then
		echo "Test $i					  ${TASK_SCORE}p/${TASK_SCORE}p"
		TOTAL=$((TOTAL + TASK_SCORE))
	else
		echo "Test $i					  0p/${TASK_SCORE}p"
	fi
done

echo
printf "Total score:				%02dp/%02dp\n" ${TOTAL} ${MAX_SCORE}

make clean > /dev/null 2>&1
