#!/bin/bash

# This script is used to run the tool_maker agent in various configurations.
# It is controlled by both environment variables and user specifiable
# options which makes it versatile enough for local testing.

# This function displays usage information for this script
usage() {
    printf "%-30s%s\n" "Toolmaker" "Agent toolmaker."
    printf "Usage: %s [options]\n\n" "$0"
    printf "  %-25s%-35s%s\n" "Short, Long" "Description" "Environment Variable"
    printf "  %-25s%-35s%s\n" "-h, --help" "Show this help message and exit" "n/a"
    printf "  %-25s%-35s%s\n" "-d, --debug" "Enable debug mode" "DEBUG"
    printf "  %-25s%-35s%s\n" "-i, --jupyter-host" "Jupyter development host" "JUPYTER_HOST"
    printf "  %-25s%-35s%s\n" "-p, --jupyter-port" "Jupyter development port" "JUPYTER_PORT"
    exit 1
}

# This function parses the command line arguments
parse_args() {
    local OPTIONS
    OPTIONS=$(getopt -o h,d,p:,i: --long help,debug,jupyter-host:,jupyter-port: -n 'parse-options' -- "$@")
    if [ $? != 0 ]; then
        echo "Failed parsing options." >&2
        exit 1
    fi
    eval set -- "$OPTIONS"
    while true; do
        case "$1" in
        -h | --help)
            usage
            ;;
        -d | --debug)
            set -x
            if [ -z "$DEBUG" ]; then
                export DEBUG=false
            else
                echo "W: Debug mode is already set by environment variable: DEBUG" >&2
            fi
            shift
            ;;
        -i | --jupyter-host)
            if [ -z "$2" ]; then
                echo "E: Missing Jupyter host name" >&2
                exit 1
            fi
            if [ -z "$JUPYTER_HOST" ]; then
                export JUPYTER_HOST=$2
            else
                echo "W: Jupyter development host is already set by environment variable: JUPYTER_HOST" >&2
            fi
            shift 2
            ;;
        -p | --port)
            if [ -z "$2" ]; then
                echo "E: Missing port number" >&2
                exit 1
            fi
            if [ -z "$JUPYTER_PORT" ]; then
                export JUPYTER_PORT=$2
            else
                echo "W: Jupyter development port is already set by environment variable: JUPYTER_PORT" >&2
            fi
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "E: Invalid option: " >&2
            exit 1
            ;;
        esac
    done
    if [ -z "$DEBUG" ]; then
        export DEBUG=false
        echo "W: Debug mode is not set, defaulting to: DEBUG=$DEBUG" >&2
    fi
    if [[ "$DEBUG" == "true" ]] && [ -z "$JUPYTER_HOST" ]; then
        echo "W: -d | --debug (DEBUG) expects -i | --jupyter-host-ip (JUPYTER_HOST), but none was provided" >&2
        exit 1
    fi
    if [[ "$DEBUG" == "true" ]] && [ -z "$JUPYTER_PORT" ]; then
        echo "E: -d | --debug (DEBUG) expects -p | --jupyter-port (JUPYTER_PORT), but none was provided" >&2
        exit 1
    fi
}

parse_args "$@"

# Set the current directory to the directory of this script
export BACKUP_PYTHONPATH=$PYTHONPATH
export PYTHONPATH=$PYTHONPATH:$(pwd)

if [ "$DEBUG" = true ]; then
    echo "I: Debug mode is enabled, starting the jupyter lab..."
    jupyter lab --ip=$JUPYTER_HOST --port $JUPYTER_PORT --allow-root --NotebookApp.custom_display_url=http://127.0.0.1:$JUPYTER_PORT
fi

export PYTHONPATH=$BACKUP_PYTHONPATH
