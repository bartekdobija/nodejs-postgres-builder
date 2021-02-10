#!/usr/bin/env bash

test()
{
    steps=$1

    su - postgres -c "pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log"
    
    if [ ! -z "$2" ]
    then
        IFS="," read -r -a data <<< $2
        echo "loading data from files: ${data[@]}"
        cat ${data[@]} | psql -U postgres -h 127.0.0.1
    fi

    echo "running: npm run $steps"
    eval "npm run $steps"
}

help()
{
    echo "Postgres & node.js tester"
    echo "Usage: $0 -s <sql_files> -t <test_step>"
    echo "Example: $0 -s data1.sql,data2.sql -t test-cicd"
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

    if [ -z "${steps}" ]
    then
        help
        exit 1
    fi 

    test $steps $data
}

main "$@"