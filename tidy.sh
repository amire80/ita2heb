#!/bin/bash

FILENAME=$1

echo checking syntax
perl -c $FILENAME
if [ $? -ne 0 ]; then
    exit 1
fi

echo tidying
perltidy $FILENAME
if [ $? -ne 0 ]; then
    exit 1
fi

diff $FILENAME.bak $FILENAME
diff_exit_code=$?

case $diff_exit_code in
0)
    rm $FILENAME.bak
;;
2)
    echo trouble in diff after perltidy, exiting.
    exit 1
;;
esac

echo criticizing
perlcritic -brutal $FILENAME

exit $?
