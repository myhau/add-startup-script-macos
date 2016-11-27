#!/usr/bin/env bash

output_dir="$HOME/Library/LaunchAgents"


if [ -z $1 ]; then
    echo "Script path must be defined"
    echo "Usage: prog <script_path> [<launchd_script_name>]"
    exit 1
fi

echo "remember that script must be executable"

bash_script_path=$1

launchd_script_name=""

if [ -n "$2" ]; then
    launchd_script_name=$2
else
    launchd_script_name="com.`whoami`""${bash_script_path//[\/\-_]/.}"
fi

file_template='
 <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
  <key>Label</key>
    <string>'$launchd_script_name'</string>
    <key>Program</key>
    <string>'$bash_script_path'</string>
    <key>RunAtLoad</key>
    <true/>
 </dict>
 </plist>
'

output_script_path="$output_dir/$launchd_script_name.plist"

echo "script will be saved in $output_script_path"

echo $file_template > $output_script_path

launchctl remove $launchd_script_name
launchctl load $output_script_path

echo "script loaded you need to relog now or check task with: launchctl start $launchd_script_name"

echo "To remove script do: rm $output_script_path; launchctl remove $launchd_script_name"