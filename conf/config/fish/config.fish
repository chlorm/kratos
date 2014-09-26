function add_to_path
	set done 0
	for path in $PATH
		if [ "$path" = "$argv[1]" ]
			set done 1
		end
	end
	if [ "$done" -eq 0 ]
		set -x PATH $PATH $argv[1]
	end
end

function t
	acpi -b
	date
end

function symlink
	mkdir -p (dirname "$argv[2]")
	set path (readlink -f "$argv[2]")
	if [ "$path" != "$argv[1]" ]
		rm -rf "$argv[2]"
		ln -s "$argv[1]" "$argv[2]" ^/dev/null; or return 1
	end
end

function dir_tmp
	set -g DIR_TMP ""
	dir_tmp_tryall
	if [ "$DIR_TMP" = "" ]
		echo "Failed to find a temporary folder" >&2
		return 1;
	end
	mkdir -p -m 0700 "$DIR_TMP"
	symlink "$DIR_TMP" "$HOME/.tmp"
	mkdir -p "$DIR_TMP/cache"
	symlink "$DIR_TMP/cache" "$HOME/.cache"
end

function dir_tmp_tryall
	dir_tmp_one "$ROOT/dev/shm"; and return 0
	dir_tmp_one "$ROOT/run/shm"; and return 0
	dir_tmp_one "$ROOT/tmp"; and return 0
	dir_tmp_one "$ROOT/var/tmp"; and return 0
	return 1
end

function dir_tmp_one
  [ -w "$argv[1]" ]; or return 1
  mount | grep '\(tmpfs\|ramfs\)' | grep $argv[1] >/dev/null; or return 1
  set id (id -u)
  set -g DIR_TMP "$argv[1]/tmp-$id"
end

set -x EDITOR vim
set -x PAGER "less -R"
set -x BLOCKSIZE M

add_to_path "$HOME/.bin"
dir_tmp
