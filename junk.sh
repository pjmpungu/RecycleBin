#!/bin/bash
###########################################################
#Name: junk.sh
#Last Modified: Jan 27 2023
#Description: Acts as a recycle bin for files
###########################################################

#variable to hold the default usage message
usage_message="Usage: junk.sh [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
"

#boolean variables to hold flag count
help_flag=0
list_flag=0
purge_flag=0

#recursive function for deleting files in a folder
recurse_purge(){
        #start at current directory. if we're at file,
        #delete the file. if we're at a directory make
        #a recursive call
        for file in "$1"/.[!.]* "$1"/*; do
                if [ -d "$file" ]; then
                        parent_dir="$file"
                        recurse_purge "$file"
                        rmdir "$parent_dir"
                elif [ -f "$file" ]; then
                        rm "$file"
                fi
        done
}

#using getopts for error handling
while getopts ":hlp" option; do
        case "$option" in
                h)
                help_flag=$(( help_flag + 1 ))
                ;;
                l)
                list_flag=$(( list_flag + 1 ))
                ;;
                p)
                purge_flag=$(( purge_flag + 1 ))
                ;;
                ?) printf "Error: Unknown option '-%s'.\n" "$OPTARG" >&2
                printf "$usage_message" >&2
                exit 1
                ##should usage message go to standard output or error??
                ;;
        esac
done

#now test to see if the correct number of command line arguments were given
if [ $# -eq 0 ]; then
        printf "$usage_message" >&1
elif [[ $# -gt 1 ]] && [[ $(( help_flag + list_flag + purge_flag )) -ge 1 ]]; then
        printf "Error: Too many options enabled.\n%s" "$usage_message" >&2
        exit 1
fi

#check if .junk directory exists, creates it if it doesn't
if [ -a "$HOME/.junk" ]; then
        true
else
        mkdir $HOME/.junk
fi

#now test to see which line arguments were passed
if [ $(( help_flag )) -eq 1 ]; then
        printf "$usage_message" >&1
        exit 0
elif [ $(( list_flag )) -eq 1 ]; then
        cwd=$(pwd)
        cd "$HOME/.junk"
        ls -lAF
        cd "$cwd"
        exit 0
elif [ $(( purge_flag )) -eq 1 ]; then
        #loop through files in .junk folder
        recurse_purge "$HOME/.junk"
        exit 0
fi

#if only files were passed as arguments, add them to the .junk directory

while [ ! $# -eq 0 ]; do
        if [[ ! -f "$1" ]] && [[ ! -d "$1" ]]; then
                printf "Warning: '%s' not found\n" "$1" >&2
        else
                mv "$1" "$HOME/.junk"
        fi
        shift
done

exit 0
