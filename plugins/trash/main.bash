# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Trash Bin Utiliy (coreutils `rm' compliant)

# Complies to XDG specification:
# http://freedesktop.org/wiki/Specifications/trash-spec/

# TODO:
# + Create trashinfo file
# + Find way to create a unique id for each item trashed
#    *an item may be a single file, many files, dirs, etcs all deleted at the same time
# + Place trashbin contents in unique dir named with unique id
# + When restoring files if the directory containing the delted contents was removed
#    then the directories need to be recreated

#[Trash Info]
#Path=/home/cwopel/Videos/Television/from.dusk.till.dawn-the.series/SMALL%20%28copy%29.JPG
#DeletionDate=2014-10-29T19:10:25

#[Trash Info]
#Path=[orginal path including the orginal filename]
#DeletionDate=[ISO 8601 compliant date and time]

function Trash::Usage {

cat <<EOF
usage info will go here
EOF

}

function trash {

  # Check for input
  [ -z "$1" ] && { Debug::Message 'error' "no input provided" ; return 1 ; }

  # Make sure necessary directories exist before continuing
  Directory::Create "$DIR_TRASH_FILES" || return 1
  Directory::Create "$DIR_TRASH_INFO" || return 1

    case $1 in

      'delete')
        shift
        # TODO: allow deletion of specific files and directories
        ## Bypasses the trash-bin and permanently deletes the target
        echo "incomplete: rm passthrough for now"
        # TODO: grep $@ for trash directories and if a match is found exit with error
        rm $@
        ;;

      'empty')
        # Clear all files in trash
        # TODO: read files in $HOME/.local/share/Trash/info and
        # delete the .trashinfo file and the file it references
        # TODO: prompt for confirmation before deleting multiple
        # files or directories
        # TODO: add total file count and size to deletion prompt
        # TODO: make an optional verbose flag

        TotalTrashSize="0"
        TotalTrashFiles="0"

        for TrashInfo in "$DIR_TRASH_INFO"; do
          # Get filename INCOMPLETE
          FindFileName=$(ls -al .trashinfo | awk -F " " '{ print $5 }')
          # remove trashinfo extension
          # if -f file exists
          if [ -f fileExists ]; then
            # Get filesize INCOMPLETE
            FindFileSize=$(ls -al .trashinfo | awk -F " " '{ print $9 }')
            # Add filesize to total
            TotalTrashSize=$(( $FindFileSize + $TotalTrashSize ))
            # Add one to file counter
            TotalTrashfiles=$(( 1 + $TotalTrashFiles ))
          fi
        done
        # Convert totalTrashSize to a human readable format (Kb/Mb/Gb/Tb)INCOMPLETE
        TotalTrashSize="incomplete"

        # Ask user if they want to delete xfiles to free up xspace
        echo "Are you sure you want to permanently delete $totalTrashfiles($totalTrashSize) (Y/N)"
        read confirmDeletion

        while [ "$confirmDeletion" != "y" ] || \
              [ "$confirmDeletion" != "n" ]; do
          case "$confirmDeletion" in
            Y|y)
              #delete files

              for trashinfo in "$DIR_TRASH_INFO"; do
                # Read trashinfo file
                findFileName=$(ls -al .trashinfo | awk -F " " '{ print $5 }')

                # find file in $DIR_TRASH_FILES with matching name

                # delete file in $DIR_TRASH_FILES and if successful, delete file in $DIR_TRASH_INFO
              done
              ;;
            N|n)
              return 0
              ;;
            *)
              ErrError "Invalid response"
              echo
              echo "Are you sure you want to permanently delete $numTrashFiles($sizeTrashFiles) (Y/N)"
              read confirmDeletion
              ;;
          esac
        done
        ;;

      'list')
        # Lists the contents of the trash bin
        # TODO: add trash files and directories to a file (an index of trash contents)
        # WILL NOT WORK ONCE RANDOM NAMING IS IMPLEMENTED, NEEDS TO BE FIXED
        ls -ARhgo --group-directories-first $DIR_TRASH_FILES



  find $DIR_TRASH_INFO -type f -name '*.trashinfo' | \
  while IFS= read -r f; do
    echo "$f"
  done
  for f in *.trashinfo; do
   echo "test"
  done


  for i in */; do
    cd "$i"
    for f in *.trasfinfo ; do
      cat "$f"
    done
    cd ..
  done


        for i in "$DIR_TRASH_INFO"; do
          cat $1 | grep "path"
          cat $1 | grep "filename"

          # print filename filesize orginal file path
        done
        ;;
      -h|--help)
        usage
        ;;

      *) # If no trash flags were found look for rm flags
        if [ -f $@ ] || [ -d $@ ]; then
          # TODO: This will handle the 'rm' functionality and compatibility layer
          # TODO: implement ALL 'rm' options to ensure compatability, the options
          # will be mapped by the compatibility layer to trash options, this
          # ensures that trash will be a drop-in replacement for rm
          echo "delete files"
          # TODO: add while loop or similiar functionality
          # Currently will not work as is
          # Parse for 'rm' options and map to Trash
          case $@ in
            -d|--dir)
              ;;
            -f|--force)
              ;;
            -i)
              ;;
            -I)
              ;;
            --interactive[=WHEN])
              ;;
            --help)
              ;;
            --no-preserve-root)
              echo "This action is not permitted by Trash"
              ;;
            --one-file-system)
              ;;
            --preserve-root)
              # Always enabled, must be manually disabled in the code for Trash
              ;;
            -r|-R|--recursive)
              ;;
            -v|--verbose)
              ;;
            --version)
              echo "Trash version: $VERSION"
              ;;
          esac
        else
          ErrError "invalid option: $1"
          echo
          TrashUsage
          return 1
        fi
        ;;

    esac

  # Check for input
  [ -z $@ ] && { echo "ERROR: no input provided" ; return 1 ; }

  # Make sure necessary directories exist before continuing
  #dir_exist "$DIR_TRASH_FILES" || return 1
  #dir_exist "$DIR_TRASH_INFO" || return 1

    case $1 in

      'delete')
        shift
        # TODO: allow deletion of specific files and directories
        ## Bypasses the trash-bin and permanently deletes the target
        echo "incomplete: rm passthrough for now"
        # TODO: grep $@ for trash directories and if a match is found exit with error
        rm $@
        ;;

      'empty')
        # Clear all files in trash
        # TODO: read files in $HOME/.local/share/Trash/info and
        # delete the .trashinfo file and the file it references
        # TODO: prompt for confirmation before deleting multiple
        # files or directories
        # TODO: add total file count and size to deletion prompt
        # TODO: make an optional verbose flag

        totalTrashSize="0"
        totalTrashFiles="0"

        for trashinfo in "$DIR_TRASH_INFO"; do
          # Get filename INCOMPLETE
          findFileName=$(ls -al .trashinfo | awk -F " " '{ print $5 }')
          # remove trashinfo extension
          # if -f file exists
          if [ -f fileExists ]; then
            # Get filesize INCOMPLETE
            findFileSize=$(ls -al .trashinfo | awk -F " " '{ print $9 }')
            # Add filesize to total
            totalTrashSize=$(( $findFileSize + $totalTrashSize ))
            # Add one to file counter
            totalTrashfiles=$(( 1 + $totalTrashFiles ))
          fi
        done
        # Convert totalTrashSize to a human readable format (Kb/Mb/Gb/Tb)INCOMPLETE
        totalTrashSize="incomplete"

        # Ask user if they want to delete xfiles to free up xspace
        echo "Are you sure you want to permanently delete $totalTrashfiles($totalTrashSize) (Y/N)"
        read confirmDeletion

        while [ "$confirmDeletion" != "y" ] || \
              [ "$confirmDeletion" != "n" ]; do
          case "$confirmDeletion" in
            Y|y)
              #delete files

              for trashinfo in "$DIR_TRASH_INFO"; do
                # Read trashinfo file
                findFileName=$(ls -al .trashinfo | awk -F " " '{ print $5 }')

                # find file in $DIR_TRASH_FILES with matching name

                # delete file in $DIR_TRASH_FILES and if successful, delete file in $DIR_TRASH_INFO
              done
              ;;
            N|n)
              return 0
              ;;
            *)
              echo "ERROR: Invalid response"
              echo
              echo "Are you sure you want to permanently delete $numTrashFiles($sizeTrashFiles) (Y/N)"
              read confirmDeletion
              ;;
          esac
        done
        ;;

      'list')
        # Lists the contents of the trash bin
        # TODO: add trash files and directories to a file (an index of trash contents)
        # WILL NOT WORK ONCE RANDOM NAMING IS IMPLEMENTED, NEEDS TO BE FIXED
        ls -ARhgo --group-directories-first $DIR_TRASH_FILES



  find $DIR_TRASH_INFO -type f -name '*.trashinfo' | \
  while IFS= read -r f; do
    echo "$f"
  done
  for f in *.trashinfo; do
   echo "test"
  done


  for i in */; do
    cd "$i"
    for f in *.trasfinfo ; do
      cat "$f"
    done
    cd ..
  done


        for i in "$DIR_TRASH_INFO"; do
          cat $1 | grep "path"
          cat $1 | grep "filename"

          # print filename filesize orginal file path
        done
        ;;
      -h|--help)
        usage
        ;;

      *) # If no trash flags were found look for rm flags
        if [ -f $@ ] || [ -d $@ ]; then
          # TODO: This will handle the 'rm' functionality and compatibility layer
          # TODO: implement ALL 'rm' options to ensure compatability, the options
          # will be mapped by the compatibility layer to trash options, this
          # ensures that trash will be a drop-in replacement for rm
          echo "delete files"
          # TODO: add while loop or similiar functionality
          # Currently will not work as is
          # Parse for 'rm' options and map to Trash
          case $@ in
            -d|--dir)
              ;;
            -f|--force)
              ;;
            -i)
              ;;
            -I)
              ;;
            --interactive[=WHEN])
              ;;
            --help)
              ;;
            --no-preserve-root)
              echo "This action is not permitted by Trash"
              ;;
            --one-file-system)
              ;;
            --preserve-root)
              # Always enabled, must be manually disabled in the code for Trash
              ;;
            -r|-R|--recursive)
              ;;
            -v|--verbose)
              ;;
            --version)
              echo "Trash version: $VERSION"
              ;;
          esac
        else
          echo "ERROR: invalid option: $1"
          echo
          TrashUsage
          return 1
        fi
        ;;

    esac
}