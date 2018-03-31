alias rsync-to='rsync -rzvpi --include-from="/home/jgould/.rsync_include" --exclude="/*" ~/. jgould@ember:~/'

alias rsync-from='rsync -rzvip --include-from="/home/jgould/.rsync_include" --exclude="/*" jgould@ember:~/. ~/.'
