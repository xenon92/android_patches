#!/bin/sh

CURRENTPATH=$(readlink -f "$0")
PATCHBASEPATH=$(dirname "$CURRENTPATH")/platform
SOURCEBASEPATH=$(readlink -f "$PATCHBASEPATH/../../")

for i in $(find "$PATCHBASEPATH"/* -type d); do
        PATCHNAME=$(basename "$i")
        PATCHTARGET=$PATCHNAME
        for i in $(seq 4); do
                PATCHTARGET=$(echo $PATCHTARGET | sed 's/_/\//')
                if [ -d "$SOURCEBASEPATH/$PATCHTARGET" ]; then break; fi
        done
        echo
        echo "==========================================================="
        echo
        echo applying $PATCHNAME to $PATCHTARGET
        echo
        cd "$SOURCEBASEPATH/$PATCHTARGET" || exit 1
        echo

        # The "repo sync ." command is to fetch the current repo
        # again and discard the already applied commit, if any.
        # The next command applies the patches again.
        # This helps in reducing "git am" errors if patch is 
        # already applied.

        repo sync .
        echo
        git am -3 "$PATCHBASEPATH/$PATCHNAME"/* || exit 1
        echo
done
