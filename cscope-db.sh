#!/usr/bin/env bash

DATABASE_FILE=cscope.files

function database_create_filelist()
{
	find . -name "*.cpp" -o -name "*.c" -o -name "*.h" >  ${DATABASE_FILE}
}

function database_filter_lines()
{
	if [ $# -ne 2 ]; then
		printf "database_filter_lines <file> <field>\n"
		return 1
	fi

	# delete all of lines with <pattern> $2 in file $1
	# double quote with bash variable
	sed -i "/$2/d" $1
}

function database_filter_files()
{
	if [ $# -ne 1 ]; then
		printf "database_filter_files need database file argument\n"
		return 1
	fi

	database_filter_lines $1 "unittest"
	database_filter_lines $1 "sandbox"
	database_filter_lines $1 "testing"
}

function database_generate_index()
{
	cscope -Rkq -i ${DATABASE_FILE}
}

function database_help()
{
	printf "database.sh support <sub-command>\n"
	printf "\tgenerate: search project and generate/filter project source code files\n"
	printf "\tindex   : cscope index all of project source code files\n"
	printf "\tall     : generate, index all-in-one\n"
}

if [ $# -ne 1 ]; then
	database_help
	exit 1
fi

if [ "$1" == "generate" ]; then
	# clean old cscope files
	rm -rf cscope.*

	database_create_filelist
	database_filter_files ${DATABASE_FILE}

elif [ "$1" == "index" ]; then
	database_generate_index

elif [ "$1" == "all" ]; then
	rm -rf cscope.*

	database_create_filelist
	database_filter_files ${DATABASE_FILE}
	database_generate_index
fi
