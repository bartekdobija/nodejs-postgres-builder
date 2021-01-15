#!/usr/bin/env bash

test()
{
    data=$1
    steps=$2
    
    su - postgres -c "pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log"
    cat $data | psql -U postgres -h 127.0.0.1
    echo "running: npm run $steps"
    eval "npm run $steps"
}

help()
{
    echo "Postgres & node.js tester"
    echo "Usage: $0 -s <sql_files> -t <test_step>"
    echo "Example: $0 -s data.sql -t test-cicd"
}

version()
{
    echo "v.0.1"
}

main() 
{
    while getopts s:t:V opts; do
        case ${opts} in
            t) steps=${OPTARG} ;;
            s) data=${OPTARG} ;;
            V) 
                version 
                exit 0 ;;
        esac
    done

    if [ -z "${data}" ] || [ -z "${steps}" ]
    then
        help
        exit 1
    fi 

    test $data $steps
}

main "$@"