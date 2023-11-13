#!/bin/bash -e
current_dir=$(pwd)
pushd "$current_dir"
set -x

# sort imports one per line, so autoflake can remove unused imports
isort --recursive  --force-single-line-imports --apply ./

# remove all unused imports, variables, functions and classes
autoflake --remove-all-unused-imports --recursive --remove-unused-variables --in-place ./ --exclude=__init__.py

# format code
black 

# isort again to fix any import ordering issues that black may have created
isort --recursive --apply ./
popd    