# RecycleBin

Simple bash script to provide the basic functionality of a recycle bin. In addition to moving files into the recycle bin directory, the script must be able to list and purge the files that have been placed into the recycle bin. This script acts as a substitute for the rm command, giving the user a chance to recover files deleted accidentally. Follows below specification.

 $ ./junk.sh
 Usage: junk.sh [-hlp] [list of files]
     -h: Display help.
     -l: List junked files.
     -p: Purge all files.
     [list of files] with no other arguments to junk those files.
