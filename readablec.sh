#!/bin/sh

set -xe

find . -type f -iname "*.c" -exec sh -c "echo {}; sed -e '/^\#line/d' -e '/^\/\*/d' -e 's/\/\*.*\*\///g' -e '/^ *;/d' {} | indent -kr | uniq >tmp ; mv tmp {}"  \;

