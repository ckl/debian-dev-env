BASE_PATH=`dirname "${BASH_SOURCE}"`
PWD=`pwd`

if [[ "${BASE_PATH}" == "${PWD}" ]]
then
    if [[ -e bin/activate ]]
    then
        source bin/activate
    fi
fi
