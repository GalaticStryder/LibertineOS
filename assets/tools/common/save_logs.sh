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
# FreedomOS log saver

cp /tmp/recovery.log /tmp/los_logs/
# We have not Gapps at the moment.
#mv /sdcard/open_gapps_log.txt /tmp/los_logs/
#mv /tmp/logs /tmp/los_logs/opengapps
dmesg > /tmp/los_logs/dmesg.log
mount > /tmp/los_logs/mount.log
cp -r /cache /tmp/los_logs/
cp -r /tmp/aroma /tmp/los_logs/
cp /default.prop /tmp/los_logs/
cp /fstab.* /tmp/los_logs/
cp /sdcard/arise_customize.prop /tmp/los_logs/
# TODO: Remove arise_customize.prop from sdcard.
ls -R /system > /tmp/los_logs/system.list
rm /tmp/los_logs/cache/*_boot*
rm /tmp/los_logs/aroma/update-binary
mkdir -p /sdcard/LibertineOS
tar -czvf /sdcard/LibertineOS/installer_log.tar.gz /tmp/los_logs/*
find /tmp/* -maxdepth 0 ! -path /tmp/recovery.log  -exec rm -rf {} +
