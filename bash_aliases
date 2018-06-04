alias rsync-to='rsync -rzvpi --size-only --include-from="/home/jgould/.rsync_include" --exclude="/*" ~/. jgould@ember:~/'

alias rsync-from='rsync -rzvip --size-only --include-from="/home/jgould/.rsync_include" --exclude="/*" jgould@ember:~/. ~/.'
