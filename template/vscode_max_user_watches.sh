sudo cat /proc/sys/fs/inotify/max_user_watches
echo "Change..."
sudo sysctl fs.inotify.max_user_watches=524288
sudo cat /proc/sys/fs/inotify/max_user_watches

