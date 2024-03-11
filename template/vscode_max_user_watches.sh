#!/bin/bash

current_value=$(cat /proc/sys/fs/inotify/max_user_watches)
desired_value=524288
if [ "$current_value" -ge "$desired_value" ]; then
    echo "Max file watchers is already set to $desired_value!"
    exit 0
fi

echo "Change the max file watchers to $desired_value ..."

sudo sysctl fs.inotify.max_user_watches=524288
if [ $? -ne 0 ]; then
    echo "Failed to change the max file watchers!"
    exit 1
fi

cat /proc/sys/fs/inotify/max_user_watches
echo "Max file watchers changed successfully!"
