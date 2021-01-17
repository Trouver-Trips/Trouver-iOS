#!/bin/bash

git=$(sh /etc/profile; which git)
build_number=`date "+%Y%m%d"`
git_release_version=$("$git" tag --sort=-v:refname -l | sed -n '1p' | sed -n 's/\(.*\)/\1/p')

target_plist="$SCRIPT_INPUT_FILE_0"
dsym_plist="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"

for plist in "$target_plist" "$dsym_plist"; do
  if [ -f "$plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$plist"
  fi
done

# Also update Settings bundle's version field
settings_bundle_plist="$TARGET_BUILD_DIR/Stream.app/Settings.bundle/Root.plist"
if [ -f "$settings_bundle_plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:0:DefaultValue ${git_release_version#*v}.$build_number" "$settings_bundle_plist"
fi