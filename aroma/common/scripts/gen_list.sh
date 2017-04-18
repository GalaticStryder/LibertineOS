#!/sbin/sh
# Copyright 2017 Antoine GRAVELOT
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# FreedomOS app list generator

# The installer list contain only the ticked apps in the aroma settings, but
# some apps need more than one file to remove their depencies.
# So here we declare the uneeded depencies that will be appended to the sapos.prop.

live_wallpaper_list="
LiveWallpapersPicker
"

gallery_list="
GallerySyncService
LetvGalleryRefocus
"

pano_list="
supersearch
"

calendar_list="
LeUICalendarImporter
GoogleCalendarSyncAdapter
"

assist_list="
VoiceAssistant
VoicePrintService
"

bug_list="
BugPostbox
LetvDebugUtil
LetvSystemReport
LetvUsageStatsReporter
"

# Generate a list file with only the wanted apps
rm -f /tmp/aroma/sapos.prop
cp /tmp/aroma/aromasapos.prop /tmp/aroma/sapos.prop

if [[ $(grep -c inclorexcl=1 /tmp/aroma/aromasapos.prop) == "1" ]]; then
  # Maybe not used...
  sed -i '/=1/d' /tmp/aroma/sapos.prop
  sed -i 's/=0//g' /tmp/aroma/sapos.prop
else
  # Most likely exclude!
  sed -i '/=0/d' /tmp/aroma/sapos.prop
  sed -i 's/=1//g' /tmp/aroma/sapos.prop
fi

# Remove uneeded entry
sed -i '/inclorexcl/d' /tmp/aroma/sapos.prop

# Add unwanted files to sapos.prop
if [[ $(grep -c "LiveWallpapers" /tmp/aroma/sapos.prop) == "1" ]]; then
  for app in $live_wallpaper_list; do
    echo -e $app >> /tmp/aroma/sapos.prop
  done
fi

if [[ $(grep -c "LetvGallery2" /tmp/aroma/sapos.prop) == "1" ]]; then
  for app in $gallery_list; do
    echo -e $app >> /tmp/aroma/sapos.prop
  done
fi

if [[ $(grep -c "LeSo" /tmp/aroma/sapos.prop) == "1" ]]; then
  for app in $pano_list; do
    echo -e $app >> /tmp/aroma/sapos.prop
  done
fi

if [[ $(grep -c "Calendar" /tmp/aroma/sapos.prop) == "1" ]]; then
  for app in $calendar_list; do
    echo -e $app >> /tmp/aroma/sapos.prop
  done
fi

if [[ $(grep -c "LetvVoiceAssistant" /tmp/aroma/sapos.prop) == "1" ]]; then
  for app in $assist_list; do
    echo -e $app >> /tmp/aroma/sapos.prop
  done
fi

if [[ $(grep -c "LetvBugServices" /tmp/aroma/sapos.prop) == "1" ]]; then
  for app in $bug_list; do
    echo -e $app >> /tmp/aroma/sapos.prop
  done
fi
