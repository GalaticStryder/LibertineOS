#!/sbin/sh
# Copyright 2016 Antoine GRAVELOT
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

/tmp/tools/busybox echo "Setting /sdcard permissions..."
/tmp/tools/busybox echo "This can take a little while!"
/tmp/tools/busybox chown -R media_rw:media_rw /data/media
# Delete local.prop crap.
/tmp/tools/busybox rm /data/local.prop
