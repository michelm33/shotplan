#!/bin/bash
###############################################################################
#
# shotplan - maintenance script to update version nums before release
#
# Copyright (c) 2024-2026 Michel Mehl. All rights reserved.
#
# ------------------------------------------------------------------------------
#
#
# ------------------------------------------------------------------------------
#
# Report bugs to michel.mehl@slashetc.fr
#
###############################################################################
DIRNAME="${BASH_SOURCE[0]%/*}"
MYDIR="$(readlink -f "${DIRNAME}")"

# Script works fine only if versions of arcv, arcv-test 
#  shellapi and shotplan change all together.
# If this is not the case, the variables may be originally hardcoded
# here. If the var is defined, the matching VERSION.txt won't be read

if [ ! -v SHOTPLAN_VERSION ] ; then
    SHOTPLAN_VERSION="$(awk -F'.' '{ printf("%s.%s-%s" ,$1,$2,$3);}' "${MYDIR}/VERSION.txt")"
fi

if [ ! -v SHELLAPI_VERSION ] ; then
    SHELLAPI_VERSION="$(awk -F'.' '{ printf("%s.%s-%s" ,$1,$2,$3);}' "${MYDIR}/shell-api/VERSION.txt")"
fi

#
# Update version nums in install script
#

#
# Update version nums in pack/debian/control
#

processedFile="${MYDIR}/pack/debian/control"

tmpf=$(mktemp)
cat "${processedFile}" | awk -F":" \
-v SHELLAPI_VERSION=${SHELLAPI_VERSION} \
'
{ 
    if ($1 == "Depends") {
        print $1 ":" " ${shlibs:Depends}, ${misc:Depends}, " "shell-api (=" SHELLAPI_VERSION ")"
    } else {
        print $0
    }
}
' > "$tmpf"

diff "$tmpf" "${processedFile}" &>/dev/null
if [ $? -ne 0 ] ; then
    echo "Updating $processedFile"
    mv "$tmpf" "$processedFile"
else 
    echo "No change for $processedFile"
    rm "$tmpf"
fi


#
# Update version nums in readme.asciidoc
# dummy example:
#    'shotplan_1.0-0' => 'shotplan_1.0-1'
#

processedFile="${MYDIR}/README.asciidoc"
tmpf=$(mktemp)
cat "${processedFile}" \
| sed -E "s/shotplan_[0-9]+\.[0-9]+\-[0-9]+/shotplan_${SHOTPLAN_VERSION}/g" \
> "$tmpf"


diff "$tmpf" "${processedFile}" &>/dev/null
if [ $? -ne 0 ] ; then
    echo "Updating $processedFile"
    mv "$tmpf" "$processedFile"
else 
    echo "No change for $processedFile"
    rm "$tmpf"
fi

