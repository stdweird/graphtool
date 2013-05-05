#!/bin/bash

rm -Rf dist build
python setup.py clean bdist_rpm

rpm_target=`ls dist/${package}*noarch.rpm`
rpm_target_name=`basename ${rpm_target}`

if [ -z "$1" ]; then
    release="\\2"
else
    release="$1"
fi

rpmrebuild --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" \
    --change-spec-preamble="sed -e 's/^Name:\(\s\s*\)\(.*\)/Name:\1python-\2/'" \
    --change-spec-provides="sed -e 's/${package}/python-${package}/g'" \
    --change-spec-preamble="sed -e 's/^\(Release:\s\s*\)\(.*\)\s*$/\1${release}.ug/'" \
    --directory=./dist/ \
    -n -p ${rpm_target}
